require 'fauxhai'
require 'chef/client'
require 'chef/mash'
require 'chef/providers'
require 'chef/resources'

module ChefSpec
  class Runner
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
        cookbook_path: calling_cookbook_path(caller)
      }.merge(options)

      Chef::Log.level = options[:log_level] || :warn

      Chef::Config.reset!
      Chef::Config.formatters.clear
      Chef::Config.add_formatter('chefspec')
      Chef::Config[:cache_type]    = 'Memory'
      Chef::Config[:cookbook_path] = Array(options[:cookbook_path])
      Chef::Config[:force_logger]  = true
      Chef::Config[:solo]          = true

      yield node if block_given?
    end

    #
    # Execute the specified recipes on the node, without actually converging
    # the node. This is the equivalent of `chef-apply`.
    #
    # @example Converging a single recipe
    #   chef_run.apply('example::default')
    #
    # @example Converging multiple recipes
    #   chef_run.apply('example::default', 'example::secondary')
    #
    #
    # @param [Array] recipe_names
    #   The names of the recipe or recipes to apply
    #
    # @return [ChefSpec::Runner]
    #   A reference to the calling Runner (for chaining purposes)
    #
    def apply(*recipe_names)
      recipe_names.each do |recipe_name|
        cookbook, recipe = Chef::Recipe.parse_recipe_name(recipe_name)
        recipe_path = File.join(Dir.pwd, 'recipes', "#{recipe}.rb")

        recipe = Chef::Recipe.new(cookbook, recipe, run_context)
        recipe.from_file(recipe_path)
      end

      @resources = []
      @run_context = Chef::RunContext.new(client.node, {}, client.events)

      Chef::Runner.new(@run_context).converge
      self
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

      # Reset the resource collection
      @resources = []

      client.build_node
      @run_context = client.setup_run_context

      Chef::Runner.new(@run_context).converge
      self
    end

    #
    def node
      return @node if @node

      @node = client.node
      @node.instance_variable_set(:@runner, self)
      @node.class.send(:attr_reader, :runner)
      @node
    end

    #
    # The full collection of resources for this Runner.
    #
    # @return [Array<Chef::Resource>]
    #
    def resources
      @resources ||= []
    end

    #
    # Find the resource with the declared type and resource name.
    #
    # @example Find a template at `/etc/foo`
    #   chef_run.find_resource('/etc/foo') #=> #<Chef::Resource::Template>
    #
    #
    # @param [String] type
    #   The type of resource (sometimes called `resource_name`) such as `file`
    #   or `directory`.
    # @param [String, Regexp] name
    #   The value of the name attribute or identity attribute for the resource.
    #
    # @return [Chef::Resource]
    #   The matching resource, or Nil
    #
    def find_resource(type, name)
      resources.find do |resource|
        resource.resource_name.to_s == type.to_s && (name === resource.identity || name === resource.name)
      end
    end

    #
    # The list of LWRPs to step into and evaluate.
    #
    # @return [Array<String>]
    #
    def step_into
      @step_into ||= Array(options[:step_into] || [])
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
    # @return [String] Currently includes the run_list. Format of the string may change between versions of this gem.
    #
    def to_s
      return "chef_run: #{node.run_list.to_s}" unless node.run_list.empty?
      'chef_run'
    end

    private
      def calling_cookbook_path(kaller)
        calling_spec = kaller.find { |line| line =~ /\/spec/ }
        bits = calling_spec.split(':', 2).first.split(File::SEPARATOR)
        spec_dir = bits.index('spec') || 0

        File.expand_path(File.join(bits.slice(0, spec_dir), '..'))
      end

      #
      def client
        return @client if @client

        @client = Chef::Client.new
        @client.ohai.data = Mash.from_hash(Fauxhai.mock(options).data)
        @client.load_node
        @client.build_node
        @client
      end
  end
end
