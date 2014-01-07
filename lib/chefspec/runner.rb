require 'fauxhai'
require 'chef/client'
require 'chef/mash'
require 'chef/providers'
require 'chef/resources'

module ChefSpec
  class Runner
    include ChefSpec::Normalize

    #
    # Defines a new runner method on the +ChefSpec::Runner+.
    #
    # @param [Symbol] resource_name
    #   the name of the resource to define a method
    #
    # @return [self]
    #
    def self.define_runner_method(resource_name)
      define_method(resource_name) do |identity|
        find_resource(resource_name, identity)
      end

      self
    end

    # @return [Hash]
    attr_reader :options

    # @return [Chef::RunContext]
    attr_reader :run_context

    #
    # Instantiate a new Runner to run examples with.
    #
    # @example Instantiate a new Runner
    #   ChefSpec::Runner.new
    #
    # @example Specifying the platform and version
    #   ChefSpec::Runner.new(platform: 'ubuntu', version: '12.04')
    #
    # @example Specifying the cookbook path
    #   ChefSpec::Runner.new(cookbook_path: ['/cookbooks'])
    #
    # @example Specifying the log level
    #   ChefSpec::Runner.new(log_level: :info)
    #
    #
    # @param [Hash] options
    #   The options for the new runner
    #
    # @option options [Symbol] :log_level
    #   The log level to use (default is :warn)
    # @option options [String] :platform
    #   The platform to load Ohai attributes from (must be present in fauxhai)
    # @option options [String] :version
    #   The version of the platform to load Ohai attributes from (must be present in fauxhai)
    # @option options [String] :path
    #   Path of a json file that will be passed to fauxhai as :path option
    # @option options [Array<String>] :step_into
    #   The list of LWRPs to evaluate
    #
    # @yield [node] Configuration block for Chef::Node
    #
    def initialize(options = {}, &block)
      @options = options = {
        cookbook_path: RSpec.configuration.cookbook_path || calling_cookbook_path(caller),
        role_path:     RSpec.configuration.role_path || default_role_path,
        log_level:     RSpec.configuration.log_level,
        path:          RSpec.configuration.path,
        platform:      RSpec.configuration.platform,
        version:       RSpec.configuration.version,
      }.merge(options)

      Chef::Log.level = options[:log_level]

      Chef::Config.reset!
      Chef::Config.formatters.clear
      Chef::Config.add_formatter('chefspec')
      Chef::Config[:cache_type]     = 'Memory'
      Chef::Config[:client_key]     = nil
      Chef::Config[:cookbook_path]  = Array(options[:cookbook_path])
      Chef::Config[:role_path]      = Array(options[:role_path])
      Chef::Config[:force_logger]   = true
      Chef::Config[:solo]           = true

      yield node if block_given?
    end

    #
    # Execute the given `run_list` on the node, without actually converging
    # the node.
    #
    # @example Converging a single recipe
    #   chef_run.converge('example::default')
    #
    # @example Converging multiple recipes
    #   chef_run.converge('example::default', 'example::secondary')
    #
    #
    # @param [Array] recipe_names
    #   The names of the recipe or recipes to converge
    #
    # @return [ChefSpec::Runner]
    #   A reference to the calling Runner (for chaining purposes)
    #
    def converge(*recipe_names)
      node.run_list.reset!
      recipe_names.each { |recipe_name| node.run_list.add(recipe_name) }

      return self if dry_run?

      # Expand the run_list
      expand_run_list!

      # Save the node back to the server for searching purposes
      unless Chef::Config[:solo]
        client.register
        node.save
      end

      # Setup the run_context
      @run_context = client.setup_run_context

      # Allow stubbing/mocking after the cookbook has been compiled but before the converge
      yield if block_given?

      @converging = true
      @client.converge(@run_context)
      self
    end

    #
    # The +Chef::Node+ corresponding to this Runner.
    #
    # @return [Chef::Node]
    #
    def node
      return @node if @node

      @node = client.build_node
      @node.instance_variable_set(:@runner, self)
      @node.class.send(:attr_reader, :runner)
      @node
    end

    #
    # The full collection of resources for this Runner.
    #
    # @return [Hash<String, Chef::Resource>]
    #
    def resource_collection
      @resource_collection ||= @run_context.resource_collection
    end

    #
    # Find the resource with the declared type and resource name.
    #
    # @example Find a template at `/etc/foo`
    #   chef_run.find_resource(:template, '/etc/foo') #=> #<Chef::Resource::Template>
    #
    #
    # @param [Symbol] type
    #   The type of resource (sometimes called `resource_name`) such as `file`
    #   or `directory`.
    # @param [String, Regexp] name
    #   The value of the name attribute or identity attribute for the resource.
    #
    # @return [Chef::Resource, nil]
    #   The matching resource, or nil if one is not found
    #
    def find_resource(type, name)
      begin
        return resource_collection.lookup("#{type}[#{name}]")
      rescue Chef::Exceptions::ResourceNotFound; end

      resource_collection.all_resources.find do |resource|
        resource_name(resource) == type && (name === resource.identity || name === resource.name)
      end
    end

    #
    # Find the resource with the declared type.
    #
    # @example Find all template resources
    #   chef_run.find_resources(:template) #=> [#<Chef::Resource::Template>, #...]
    #
    #
    # @param [Symbol] type
    #   The type of resource such as `:file` or `:directory`.
    #
    # @return [Array<Chef::Resource>]
    #   The matching resources
    #
    def find_resources(type)
      resource_collection.all_resources.select do |resource|
        resource_name(resource) == type.to_sym
      end
    end

    #
    # Boolean method to determine the current phase of the Chef run (compiling
    # or converging)
    #
    # @return [Boolean]
    #
    def compiling?
      !@converging
    end

    #
    # Determines if the runner should step into the given resource. The
    # +step_into+ option takes a string, but this method coerces everything
    # to symbols for safety.
    #
    # This method also substitutes any dashes (+-+) with underscores (+_+),
    # because that's what Chef does under the hood. (See GitHub issue #254
    # for more background)
    #
    # @param [Chef::Resource] resource
    #   the Chef resource to try and step in to
    #
    # @return [Boolean]
    #
    def step_into?(resource)
      key = resource_name(resource)
      Array(options[:step_into]).map(&method(:resource_name)).include?(key)
    end

    #
    # Boolean method to determine if this Runner is in `dry_run` mode.
    #
    # @return [Boolean]
    #
    def dry_run?
      !!options[:dry_run]
    end

    #
    # This runner as a string.
    #
    # @return [String] Currently includes the run_list. Format of the string
    # may change between versions of this gem.
    #
    def to_s
      return "chef_run: #{node.run_list.to_s}" unless node.run_list.empty?
      'chef_run'
    end

    #
    # The runner as a String with helpful output.
    #
    # @return [String]
    #
    def inspect
      "#<#{self.class} options: #{options.inspect}, run_list: '#{node.run_list.to_s}'>"
    end

    private
      #
      # The inferred path from the calling spec.
      #
      # @param [Array<String>] kaller
      #   the calling trace
      #
      # @return [String]
      #
      def calling_cookbook_path(kaller)
        calling_spec = kaller.find { |line| line =~ /\/spec/ }
        raise Error::CookbookPathNotFound if calling_spec.nil?

        bits = calling_spec.split(':', 2).first.split(File::SEPARATOR)
        spec_dir = bits.index('spec') || 0

        File.expand_path(File.join(bits.slice(0, spec_dir), '..'))
      end

      #
      # The inferred path to roles.
      #
      # @return [String, nil]
      #
      def default_role_path
        Pathname.new(Dir.pwd).ascend do |path|
          possible = File.join(path, 'roles')
          return possible if File.exists?(possible)
        end

        nil
      end

      #
      # The +Chef::Client+ for this runner.
      #
      # @return [Chef::Runner]
      #
      def client
        return @client if @client

        @client = Chef::Client.new
        @client.ohai.data = Mash.from_hash(Fauxhai.mock(options).data)
        @client.load_node
        @client.build_node
        @client.save_updated_node
        @client
      end

      #
      # We really need a way to just expand the run_list, but that's done by
      # +Chef::Client#build_node+. However, that same method also resets the
      # automatic attributes, making it impossible to mock them. So we are
      # stuck +instance_eval+ing against the client and manually expanding
      # the mode object.
      #
      def expand_run_list!
        client.instance_eval do
          @run_list_expansion = expand_run_list
          @expanded_run_list_with_versions = @run_list_expansion.recipes.with_version_constraints_strings
        end
      end
  end
end
