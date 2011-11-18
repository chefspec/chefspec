require 'chef'
require 'chef/client'
require 'chef/cookbook_loader'
require 'chefspec/matchers/shared'

# ChefSpec allows you to write rspec examples for Chef recipes to gain faster feedback without the need to converge a
# node.
module ChefSpec

  # The main entry point for running recipes within RSpec.
  class ChefRunner

    @step_into = []
    @resources = []

    attr_accessor :resources
    attr_reader :node

    # Instantiate a new runner to run examples with.
    #
    # @param [Hash] options The options for the new runner
    # @option options [String] :cookbook_path The path to the chef cookbook(s) to be tested.
    # @option options [Symbol] :log_level The log level to use (default is :warn)
    # @yield [node] Configuration block for Chef::Node
    def initialize(options={})
      defaults = {:cookbook_path => default_cookbook_path, :log_level => :warn, :dry_run => false}
      options = {:cookbook_path => options} unless options.respond_to?(:to_hash) # backwards-compatibility
      options = defaults.merge(options)

      the_runner = self
      @resources = []
      @do_dry_run = options[:dry_run]

      Chef::Resource.class_eval do
        alias :old_run_action :run_action

        if self.class.methods.include?(:class_variable_set)
          self.class_variable_set :@@runner, the_runner
        else
          @@runner = the_runner
        end

        def run_action(action)
          Chef::Log.info("Processing #{self} action #{action} (#{defined_at})") if self.respond_to? :defined_at
          if self.class.methods.include?(:class_variable_get)
            self.class.class_variable_get(:@@runner).resources << self
          else
            @@runner.resources << self
          end
        end
      end

      Chef::Config[:solo] = true
      Chef::Config[:cache_type] = "Memory"
      Chef::Config[:cookbook_path] = options[:cookbook_path]
      Chef::Log.verbose = true if Chef::Log.respond_to?(:verbose)
      Chef::Log.level(options[:log_level])
      @client = Chef::Client.new
      fake_ohai(@client.ohai)
      @node = @client.build_node
      if block_given?
        yield @node
      end
    end

    # Run the specified recipes, but without actually converging the node.
    #
    # @param [array] recipe_names The names of the recipes to execute
    # @return ChefSpec::ChefRunner The runner itself
    def converge(*recipe_names)
      @node.run_list.reset!
      recipe_names.each do |recipe_name|
        @node.run_list << recipe_name
      end
      return self if @do_dry_run

      @client.instance_eval do
        if defined?(@expanded_run_list_with_versions) # 0.10.x
          @run_list_expansion = @node.expand!('disk')
          @expanded_run_list_with_versions = @run_list_expansion.recipes.with_version_constraints_strings
        end
      end

      @resources = []
      if @client.respond_to?(:setup_run_context) # 0.10.x
        run_context = @client.setup_run_context
      else
        run_context = Chef::RunContext.new(@client.node, Chef::CookbookCollection.new(Chef::CookbookLoader.new)) # 0.9.x
      end
      runner = Chef::Runner.new(run_context)
      runner.converge
      self
    end

    # Find any directory declared with the given path
    #
    # @param [String] path The directory path
    # @return [Chef::Resource::Directory] The matching directory, or Nil
    def directory(path)
      find_resource('directory', path)
    end

    # Find any cookbook_file declared with the given path
    #
    # @param [String] path The cookbook_file path
    # @return [Chef::Resource::Directory] The matching cookbook_file, or Nil
    def cookbook_file(path)
      find_resource('cookbook_file', path)
    end

    # Find any file declared with the given path
    #
    # @param [String] path The file path
    # @return [Chef::Resource::Directory] The matching file, or Nil
    def file(path)
      find_resource('file', path)
    end

    # Find any template declared with the given path
    #
    # @param [String] path The template path
    # @return [Chef::Resource::Directory] The matching template, or Nil
    def template(path)
      find_resource('template', path)
    end

    # This runner as a string.
    #
    # @return [String] Currently includes the run_list. Format of the string may change between versions of this gem.
    def to_s
      return "chef_run: #{@node.run_list.to_s}" unless @node.run_list.empty?
      'chef_run'
    end

    private

    # Populate basic OHAI attributes required to get recipes working. This is a minimal set - if your recipe example
    # does conditional execution based on these values or additional attributes you can set these via
    # node.automatic_attrs.
    #
    # @param [Ohai::System] ohai The ohai instance to set fake attributes on
    def fake_ohai(ohai)
      {:os => 'chefspec', :os_version => ChefSpec::VERSION, :fqdn => 'chefspec.local', :domain => 'local',
       :ipaddress => '127.0.0.1', :hostname => 'chefspec',
       :kernel => Mash.new({:machine => 'i386'})}.each_pair do |attribute,value|
        ohai[attribute] = value
      end
    end

    # Infer the default cookbook path from the location of the calling spec.
    #
    # @return [String] The path to the cookbooks directory
    def default_cookbook_path
      Pathname.new(File.join(caller(2).first.split(':').slice(0..-3).first, "..", "..", "..")).cleanpath
    end

    # Find the resource with the declared type and name
    #
    # @param [String] type The type of resource - e.g. 'file' or 'directory'
    # @param [String] name The resource name
    # @return [Chef::Resource] The matching resource, or Nil
    def find_resource(type, name)
      resources.find{|resource| resource_type(resource) == type and resource.name == name}
    end

  end

end
