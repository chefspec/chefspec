require 'chef'
require 'chef/client'
require 'chef/cookbook_loader'
require 'fauxhai'

require 'chefspec/matchers/shared'

# ChefSpec allows you to write rspec examples for Chef recipes to gain faster feedback without the need to converge a
# node.
module ChefSpec

  # The main entry point for running recipes within RSpec.
  class ChefRunner

    @resources = []

    attr_accessor :resources
    attr_reader :step_into
    attr_reader :run_context
    attr_reader :node

    # Instantiate a new runner to run examples with.
    #
    # @param [Hash] options The options for the new runner
    # @option options [String] :cookbook_path The path to the chef cookbook(s) to be tested.
    # @option options [Symbol] :log_level The log level to use (default is :warn)
    # @option options [String] :platform The platform to load Ohai attributes from (must be present in fauxhai)
    # @option options [String] :version The version of the platform to load Ohai attributes from (must be present in fauxhai)
    # @yield [node] Configuration block for Chef::Node
    def initialize(options={})
      defaults = {:cookbook_path => default_cookbook_path, :log_level => :warn, :dry_run => false, :step_into => []}
      options = {:cookbook_path => options} unless options.respond_to?(:to_hash) # backwards-compatibility
      @options = defaults.merge(options)

      the_runner = self
      @resources = []
      @step_into = @options[:step_into]
      @do_dry_run = @options[:dry_run]

      Chef::Resource.class_eval do
        alias :old_run_action :run_action unless method_defined?(:old_run_action)

        if self.class.methods.include?(:class_variable_set)
          self.class_variable_set :@@runner, the_runner
        else
          @@runner = the_runner
        end

        def run_action(*args)
          action = args.first
          runner = if self.class.methods.include?(:class_variable_get)
            self.class.class_variable_get(:@@runner)
          else
            @@runner
          end

          if runner.step_into.include?(self.resource_name.to_s)
            # Ignore not_if / only_if guards
            if self.only_if.is_a?(Array) # 0.10.x
              self.instance_eval { @not_if = []; @only_if = [] }
            else # 0.9.x
              self.only_if { true }
              self.not_if { false }
            end
            self.old_run_action(action)
          end

          Chef::Log.info("Processing #{self} action #{action} (#{defined_at})") if self.respond_to? :defined_at
          runner.resources << self
        end
      end

      Chef::Config[:solo] = true
      Chef::Config[:cache_type] = "Memory"
      Chef::Config[:cache_options] = { :path => "#{ENV['HOME']}/.chef/checksums" }
      Chef::Cookbook::FileVendor.on_create { |manifest| Chef::Cookbook::FileSystemFileVendor.new(manifest) }
      Chef::Config[:cookbook_path] = @options[:cookbook_path]
      Chef::Config[:client_key] = nil

      # As of Chef 11, Chef uses custom formatters which munge the RSpec output.
      # This uses a custom formatter which basically tells Chef to shut up.
      Chef::Config.add_formatter('chefspec') if Chef::Config.respond_to?(:add_formatter)

      Chef::Log.verbose = true if Chef::Log.respond_to?(:verbose)
      Chef::Log.level(@options[:log_level])
      @client = Chef::Client.new
      fake_ohai(@client.ohai)
      @client.load_node if @client.respond_to?(:load_node) # chef >= 10.14.0
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
        @run_context = @client.setup_run_context
      else
        @run_context = Chef::RunContext.new(@client.node, Chef::CookbookCollection.new(Chef::CookbookLoader.new)) # 0.9.x
      end
      runner = Chef::Runner.new(@run_context)
      runner.converge
      self
    end

    FILE_RESOURCES    = %w(directory cookbook_file file template link remote_directory remote_file)
    PACKAGE_RESOURCES = %w(package apt_package dpkg_package easy_install_package freebsd_package macports_package portage_package rpm_package chef_gem solaris_package yum_package zypper_package)
    SCRIPT_RESOURCES  = %w(script powershell bash csh perl python ruby)
    MISC_RESOURCES    = %w(cron env user execute service log route ruby_block git subversion group mount ohai ifconfig deploy http_request)

    (FILE_RESOURCES + PACKAGE_RESOURCES + SCRIPT_RESOURCES + MISC_RESOURCES).sort.uniq.each do |type|
      define_method(type) do |name|
        find_resource(type, name)
      end
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
    # This method now relies on fauxhai to set node attributes.
    #
    # @param [Ohai::System] ohai The ohai instance to set fake attributes on
    def fake_ohai(ohai)
      ::Fauxhai::Mocker.new(:platform => @options[:platform], :version => @options[:version]).data.each_pair do |attribute, value|
        ohai[attribute] = value
      end
    end

    # Infer the default cookbook path from the location of the calling spec.
    #
    # @return [String] The path to the cookbooks directory
    def default_cookbook_path
      Pathname.new(File.join(caller(2).first.split(':').slice(0..-3).join(':'), '..', '..', '..')).cleanpath.to_s
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
