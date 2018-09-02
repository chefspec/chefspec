module ChefSpec
  module API
    # Module containing the core RSpec API for ChefSpec.
    module Core
      # Pull in the needed machinery to use `around` and `let` in here.
      extend RSpec::SharedContext

      # Activate all of the various ChefSpec stubs for the duraction of this
      # example block.
      around do |ex|
        old_chefspec_mode = $CHEFSPEC_MODE
        $CHEFSPEC_MODE = true
        begin
          # Only run the preload if a platform is configured via the new system
          # since otherwise it will spam warnings about the platform not being
          # set.
          chef_runner_instance.preload! if chefspec_platform
          ex.run
        ensure
          $CHEFSPEC_MODE = old_chefspec_mode
        end
      end

      # Let variables to set data in a scoped way. Used below by
      # {ClassMethods#platform}.
      let(:chefspec_default_attributes) { chefspec_attributes(:default_attributes) }
      let(:chefspec_normal_attributes) { chefspec_attributes(:normal_attributes) }
      let(:chefspec_override_attributes) { chefspec_attributes(:override_attributes) }
      let(:chefspec_automatic_attributes) { chefspec_attributes(:automatic_attributes) }
      let(:chefspec_platform) { nil }
      let(:chefspec_platform_version) { nil }

      # Compute the options for the runner.
      #
      # @abstract
      # @return [Hash<Symbol, Object>]
      def chef_runner_options
        options = {
          step_into: chefspec_ancestor_gather([], :step_into) {|memo, val| memo | val },
          default_attributes: chefspec_default_attributes,
          normal_attributes: chefspec_normal_attributes,
          override_attributes: chefspec_override_attributes,
          automatic_attributes: chefspec_automatic_attributes,
          spec_declaration_locations: self.class.declaration_locations.last[0],
        }
        # Only specify these if set in the example so we don't override the
        # global settings.
        options[:platform] = chefspec_platform if chefspec_platform
        options[:version] = chefspec_platform_version if chefspec_platform_version
        # Merge in any final overrides.
        options.update(chefspec_attributes(:chefspec_options).symbolize_keys)
        options
      end

      # Class of runner to use.
      #
      # @abstract
      # @return [Class]
      def chef_runner_class
        ChefSpec::SoloRunner
      end

      # Create an instance of the runner.
      #
      # This should only be used in cases where the `let()` cache would be a problem.
      #
      # @return [ChefSpec::SoloRunner]
      def chef_runner_instance
        chef_runner_class.new(chef_runner_options)
      end

      # Set up the runner object but don't actually run anything yet.
      let(:chef_runner) { chef_runner_instance }

      # By default, run the recipe in the base `describe` block.
      let(:chef_run) { chef_runner.converge(described_recipe) }

      # Helper method for some of the nestable test value methods like
      # {ClassMethods#default_attributes} and {ClassMethods#step_into}.
      #
      # @api private
      # @param start [Object] Initial value for the reducer.
      # @param method [Symbol] Name of the group-level method to call on each
      #   ancestor.
      # @param block [Proc] Reducer callable.
      # @return [Object]
      def chefspec_ancestor_gather(start, method, &block)
        candidate_ancestors = self.class.ancestors.select {|cls| cls.respond_to?(method) && cls != ChefSpec::API::Core }
        candidate_ancestors.reverse.inject(start) do |memo, cls|
          block.call(memo, cls.send(method))
        end
      end

      # Special case of {#chefspec_ancestor_gather} because we do it four times.
      #
      # @api private
      # @param method [Symbol] Name of the group-level method to call on each
      #   ancestor.
      # @return [Mash]
      def chefspec_attributes(method)
        chefspec_ancestor_gather(Mash.new, method) do |memo, val|
          Chef::Mixin::DeepMerge.merge(memo, val)
        end
      end

      # Methods that will end up as group-level.
      #
      # @api private
      module ClassMethods
        # Set the Fauxhai platform to use for this example group.
        #
        # @example
        #   describe 'myrecipe' do
        #     platform 'ubuntu', '18.04'
        # @param name [String] Platform name to set.
        # @param version [String, nil] Platform version to set.
        # @return [void]
        def platform(name, version=nil)
          let(:chefspec_platform) { name }
          let(:chefspec_platform_version) { version }
        end

        # Use an in-line block of recipe code for this example group rather
        # than a recipe from a cookbook.
        #
        # @example
        #   describe 'my_resource' do
        #     recipe do
        #       my_resource 'helloworld'
        #     end
        # @param block [Proc] A block of Chef recipe code.
        # @return [void]
        def recipe(&block)
          let(:chef_run) do
            chef_runner.converge_block(&block)
          end
        end

        # Set default-level node attributes to use for this example group.
        #
        # @example
        #   describe 'myapp::install' do
        #     default_attributes['myapp']['version'] = '1.0'
        # @return [Chef::Node::VividMash]
        def default_attributes
          @chefspec_default_attributes ||= Chef::Node::VividMash.new
        end

        # Set normal-level node attributes to use for this example group.
        #
        # @example
        #   describe 'myapp::install' do
        #     normal_attributes['myapp']['version'] = '1.0'
        # @return [Chef::Node::VividMash]
        def normal_attributes
          @chefspec_normal_attributes ||= Chef::Node::VividMash.new
        end

        # Set override-level node attributes to use for this example group.
        #
        # @example
        #   describe 'myapp::install' do
        #     override_attributes['myapp']['version'] = '1.0'
        # @return [Chef::Node::VividMash]
        def override_attributes
          @chefspec_override_attributes ||= Chef::Node::VividMash.new
        end

        # Set automatic-level node attributes to use for this example group.
        #
        # @example
        #   describe 'myapp::install' do
        #     automatic_attributes['kernel']['machine'] = 'ppc64'
        # @return [Chef::Node::VividMash]
        def automatic_attributes
          @chefspec_automatic_attributes ||= Chef::Node::VividMash.new
        end

        # Set additional ChefSpec runner options to use for this example group.
        #
        # @example
        #   describe 'myapp::install' do
        #     chefspec_options[:log_level] = :debug
        # @return [Chef::Node::VividMash]
        def chefspec_options
          @chefspec_options ||= Chef::Node::VividMash.new
        end

        # Add resources to the step_into list for this example group.
        #
        # @example
        #   describe 'myapp::install' do
        #     step_into :my_resource
        # @return [Array]
        def step_into(*resources)
          @chefspec_step_into ||= []
          @chefspec_step_into |= resources.flatten.map(&:to_s)
        end

        # @api private
        def included(klass)
          super
          # Inject classmethods into the group.
          klass.extend(ClassMethods)
          # If the describe block is aimed at string or resource/provider class
          # then set the default subject to be the Chef run.
          if klass.described_class.nil? || klass.described_class.is_a?(Class) && (klass.described_class < Chef::Resource || klass.described_class < Chef::Provider)
            klass.subject { chef_run }
          end
        end
      end

      extend ClassMethods

    end
  end
end
