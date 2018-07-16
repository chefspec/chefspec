require 'fauxhai'
require 'chef/client'
require 'chef/cookbook/metadata'
require 'chef/mash'
require 'chef/providers'
require 'chef/resources'

module ChefSpec
  class SoloRunner
    #
    # Handy class method for just converging a runner if you do not care about
    # initializing the runner with custom options.
    #
    # @example
    #   ChefSpec::SoloRunner.converge('cookbook::recipe')
    #
    def self.converge(*recipe_names)
      new.tap do |instance|
        instance.converge(*recipe_names)
      end
    end

    include ChefSpec::Normalize

    # @return [Hash]
    attr_reader :options

    # @return [Chef::RunContext]
    attr_reader :run_context

    #
    # Instantiate a new SoloRunner to run examples with.
    #
    # @example Instantiate a new Runner
    #   ChefSpec::SoloRunner.new
    #
    # @example Specifying the platform and version
    #   ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04')
    #
    # @example Specifying the cookbook path
    #   ChefSpec::SoloRunner.new(cookbook_path: ['/cookbooks'])
    #
    # @example Specifying the log level
    #   ChefSpec::SoloRunner.new(log_level: :info)
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
    # @option options String] :file_cache_path
    #   File caching path, if absent ChefSpec will use a temporary directory generated on the fly
    #
    # @yield [node] Configuration block for Chef::Node
    #
    def initialize(options = {})
      @options = with_default_options(options)
      apply_chef_config!
      yield node if block_given?
    end

    #
    # Execute the given `run_list` on the node, without actually converging
    # the node. Each time {#converge} is called, the `run_list` is reset to the
    # new value (it is **not** additive).
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
    # @return [ChefSpec::SoloRunner]
    #   A reference to the calling Runner (for chaining purposes)
    #
    def converge(*recipe_names)
      # Re-apply the Chef config before converging in case something else
      # called Config.reset too.
      apply_chef_config!
      @converging = false
      node.run_list.reset!
      recipe_names.each { |recipe_name| node.run_list.add(recipe_name) }

      return self if dry_run?

      # Expand the run_list
      expand_run_list!

      # Merge in provided node attributes. Default and override use the role_
      # levels so they win over the relevant bits from cookbooks since otherwise
      # they would not and that would be confusing.
      node.attributes.role_default = Chef::Mixin::DeepMerge.merge(node.attributes.role_default, options[:default_attributes]) if options[:default_attributes]
      node.attributes.normal = Chef::Mixin::DeepMerge.merge(node.attributes.normal, options[:normal_attributes]) if options[:normal_attributes]
      node.attributes.role_override = Chef::Mixin::DeepMerge.merge(node.attributes.role_override, options[:override_attributes]) if options[:override_attributes]
      node.attributes.automatic = Chef::Mixin::DeepMerge.merge(node.attributes.automatic, options[:automatic_attributes]) if options[:automatic_attributes]

      # Setup the run_context, rescuing the exception that happens when a
      # resource is not defined on a particular platform
      begin
        @run_context = client.setup_run_context
      rescue Chef::Exceptions::NoSuchResourceType => e
        raise Error::MayNeedToSpecifyPlatform.new(original_error: e.message)
      end

      # Allow stubbing/mocking after the cookbook has been compiled but before the converge
      yield node if block_given?

      @converging = true
      converge_val = @client.converge(@run_context)
      if converge_val.is_a?(Exception)
        raise converge_val
      end
      self
    end

    #
    # Execute a block of recipe code.
    #
    # @param [Proc] block
    #   A block containing Chef recipe code
    #
    # @return [ChefSpec::SoloRunner]
    #
    def converge_block(&block)
      converge do
        recipe = Chef::Recipe.new(cookbook_name, '_test', run_context)
        recipe.instance_exec(&block)
      end
    end

    #
    # Run a static preload of the cookbook under test. This will load libraries
    # and resources, but not attributes or recipes.
    #
    # @return [void]
    #
    def preload!
      # Flag to disable preloading for situations where it doesn't make sense.
      return if ENV['CHEFSPEC_NO_PRELOAD']
      begin
        old_preload = $CHEFSPEC_PRELOAD
        $CHEFSPEC_PRELOAD = true
        converge("recipe[#{cookbook_name}]")
        node.run_list.reset!
      ensure
        $CHEFSPEC_PRELOAD = old_preload
      end
    end

    #
    # The +Chef::Node+ corresponding to this Runner.
    #
    # @return [Chef::Node]
    #
    def node
      runner = self
      @node ||= begin
        apply_chef_config!
        client.build_node.tap do |node|
          node.define_singleton_method(:runner) { runner }
        end
      end
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
    # Find the resource with the declared type and resource name, and optionally match a performed action.
    #
    # If multiples match it returns the last (which more or less matches the chef last-inserter-wins semantics)
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
    # @param [Symbol] action
    #   (optional) match only resources that performed the action.
    #
    # @return [Chef::Resource, nil]
    #   The matching resource, or nil if one is not found
    #
    def find_resource(type, name, action = nil)
      resource_collection.all_resources.reverse_each.find do |resource|
        resource.declared_type == type.to_sym && (name === resource.identity || name === resource.name) && (action.nil? || resource.performed_action?(action))
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
    # @return [true, false]
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
    # @return [true, false]
    #
    def step_into?(resource)
      key = resource_name(resource)
      Array(options[:step_into]).map(&method(:resource_name)).include?(key)
    end

    #
    # Boolean method to determine if this Runner is in `dry_run` mode.
    #
    # @return [true, false]
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
      "#<#{self.class.name} run_list: [#{node.run_list}]>"
    end

    #
    # The runner as a String with helpful output.
    #
    # @return [String]
    #
    def inspect
      "#<#{self.class.name}" \
      " options: #{options.inspect}," \
      " run_list: [#{node.run_list}]>"
    end

    #
    # Respond to custom matchers defined by the user.
    #
    def method_missing(m, *args, &block)
      if block = ChefSpec.matchers[resource_name(m.to_sym)]
        instance_exec(args.first, &block)
      else
        super
      end
    end

    #
    # Inform Ruby that we respond to methods that are defined as custom
    # matchers.
    #
    def respond_to_missing?(m, include_private = false)
      ChefSpec.matchers.key?(m.to_sym) || super
    end

    private

    #
    # The path to cache files on disk. This value is created using
    # {Dir.mktmpdir}. The method adds a {Kernel.at_exit} handler to ensure the
    # temporary directory is deleted when the system exits.
    #
    # **This method creates a new temporary directory on each call!** As such,
    # you should cache the result to a variable inside you system.
    #
    def file_cache_path
      path = Dir.mktmpdir
      at_exit { FileUtils.rm_rf(path) }
      path
    end

    #
    # Set the default options, with the given options taking precedence.
    #
    # @param [Hash] options
    #   the list of options to take precedence
    #
    # @return [Hash] options
    #
    def with_default_options(options)
      config = RSpec.configuration

      {
        cookbook_root: config.cookbook_root || calling_cookbook_root(options, caller),
        cookbook_path: config.cookbook_path || calling_cookbook_path(options, caller),
        role_path:     config.role_path || default_role_path,
        environment_path: config.environment_path || default_environment_path,
        file_cache_path: config.file_cache_path,
        log_level:     config.log_level,
        path:          config.path,
        platform:      config.platform,
        version:       config.version,
      }.merge(options)
    end

    #
    # The inferred cookbook root from the calling spec.
    #
    # @param [Hash<Symbol, Object>] options
    #   initial runner options
    # @param [Array<String>] kaller
    #   the calling trace
    #
    # @return [String]
    #
    def calling_cookbook_root(options, kaller)
      calling_spec = options[:spec_declaration_locations] || kaller.find { |line| line =~ /\/spec/ }
      raise Error::CookbookPathNotFound if calling_spec.nil?

      bits = calling_spec.split(/:[0-9]/, 2).first.split(File::SEPARATOR)
      spec_dir = bits.index('spec') || 0

      File.join(bits.slice(0, spec_dir))
    end

    #
    # The inferred path from the calling spec.
    #
    # @param [Hash<Symbol, Object>] options
    #   initial runner options
    # @param [Array<String>] kaller
    #   the calling trace
    #
    # @return [String]
    #
    def calling_cookbook_path(options, kaller)
      File.expand_path(File.join(calling_cookbook_root(options, kaller), '..'))
    end

    #
    # The inferred path to roles.
    #
    # @return [String, nil]
    #
    def default_role_path
      Pathname.new(Dir.pwd).ascend do |path|
        possible = File.join(path, 'roles')
        return possible if File.exist?(possible)
      end

      nil
    end

    #
    # The inferred path to environments.
    #
    # @return [String, nil]
    #
    def default_environment_path
      Pathname.new(Dir.pwd).ascend do |path|
        possible = File.join(path, 'environments')
        return possible if File.exist?(possible)
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
    # @todo Remove in Chef 13
    #
    def expand_run_list!
      # Recent versions of Chef include a method to expand the +run_list+,
      # setting the correct instance variables on the policy builder. We use
      # that, unless the user is running an older version of Chef which
      # doesn't include this method.
      if client.respond_to?(:expanded_run_list)
        client.expanded_run_list
      else
        # Sadly, if we got this far, it means that the current Chef version
        # does not include the +expanded_run_list+ method, so we need to
        # manually expand the +run_list+. The following code has been known
        # to make kittens cry, so please read with extreme caution.
        client.instance_eval do
          @run_list_expansion = expand_run_list
          @expanded_run_list_with_versions = @run_list_expansion.recipes.with_version_constraints_strings
        end
      end
    end

    #
    # Try to load the cookbook metadata for the cookbook under test.
    #
    # @return [Chef::Cookbook::Metadata]
    #
    def cookbook
      @cookbook ||= Chef::Cookbook::Metadata.new.tap {|m| m.from_file("#{options[:cookbook_root]}/metadata.rb") }
    end

    #
    # Try to figure out the name for the cookbook under test.
    #
    # @return [String]
    #
    def cookbook_name
      # Try to figure out the name of this cookbook, pretending this block
      # is in the name context as the cookbook under test.
      begin
        cookbook.name
      rescue IOError
        # Old cookbook, has no metadata, use the folder name I guess.
        File.basename(options[:cookbook_root])
      end
    end

    #
    # Apply the required options to {Chef::Config}.
    #
    # @api private
    # @return [void]
    #
    def apply_chef_config!
      Chef::Log.level = @options[:log_level]

      Chef::Config.reset!
      Chef::Config.formatters.clear
      Chef::Config.add_formatter('chefspec')
      Chef::Config[:cache_type]      = 'Memory'
      Chef::Config[:client_key]      = nil
      Chef::Config[:client_name]     = nil
      Chef::Config[:node_name]       = nil
      Chef::Config[:file_cache_path] = @options[:file_cache_path] || file_cache_path
      Chef::Config[:cookbook_path]   = Array(@options[:cookbook_path])
      # If the word cookbook is in the folder name, treat it as the path. Otherwise
      # it's probably not a cookbook path and so we activate the gross hack mode.
      if Chef::Config[:cookbook_path].size == 1 && Chef::Config[:cookbook_path].first !~ /cookbook/
        Chef::Config[:chefspec_cookbook_root] = @options[:cookbook_root]
      end
      Chef::Config[:no_lazy_load]    = true
      Chef::Config[:role_path]       = Array(@options[:role_path])
      Chef::Config[:force_logger]    = true
      Chef::Config[:solo]            = true
      Chef::Config[:solo_legacy_mode] = true
      Chef::Config[:use_policyfile]  = false
      Chef::Config[:environment_path] = @options[:environment_path]
    end

  end
end
