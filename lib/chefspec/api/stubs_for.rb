require "chef/version"
require "mixlib/shellout" unless defined?(Mixlib::ShellOut)

module ChefSpec
  module API
    module StubsFor
      # Pull in the needed machinery to use `before` here.
      extend RSpec::SharedContext

      # Which version to use the shell_out_compacted hook on.
      HAS_SHELLOUT_COMPACTED = Gem::Requirement.create("> 14.2")

      # Hook used in the monkey patches to set up a place to inject stubs when
      # needed for a resource or provider.
      #
      # @api private
      # @param object [Chef::Resource, Chef::Provider] Resource or provider to inject
      # @param type [Symbol] Type of object to register stubs on
      # @return [void]
      def self.setup_stubs_for(object, type)
        # This space left intentionally blank, real implementation is below.
      end

      # Place to hold any stubs which should be active for this example.
      let(:_chefspec_stubs_for_registry) do
        # Auto-vivify for things like _chefspec_stubs_for_registry[:resource]['my_resource'] == [].
        Hash.new do |hash, key|
          hash[key] = Hash.new do |inner_hash, inner_key|
            inner_hash[inner_key] = []
          end
        end
      end

      # Take over from the default, no-op implementation of {.setup_stubs_for}.
      before do
        allow(StubsFor).to receive(:setup_stubs_for) do |object, type|
          type_stubs = _chefspec_stubs_for_registry[type]
          resource_object = object.respond_to?(:new_resource) ? object.new_resource : object
          stubs = type_stubs[nil] + type_stubs[resource_object.resource_name.to_s] + type_stubs[resource_object.to_s]
          stubs.each do |stub|
            instance_exec(object, &stub)
          end
        end
      end

      # Register stubs for resource objects.
      #
      # The `target` parameter can select either a resource string like `'package[foo]'`,
      # a resource name like `'package'`, or `nil` for all resources.
      #
      # @example Setting method stub on a single resource
      #   it "does a thing" do
      #     stubs_for_resource("my_resource[foo]") do |res|
      #       expect(res).to receive_shell_out.with("my_command").and_return(stdout: "asdf")
      #     end
      #     expect(subject.some_method).to eq "asdf"
      #   end
      # @param target [String, nil] Resource name to inject, or nil for all resources.
      # @param current_value [Boolean] If true, also register stubs for current_value objects on the same target.
      # @param block [Proc] A block taking the resource object as a parameter.
      # @return [void]
      def stubs_for_resource(target=nil, current_value: true, current_resource: true, &block)
        current_value = false if !current_resource
        _chefspec_stubs_for_registry[:resource][target] << block
        stubs_for_current_value(target, &block) if current_value
      end

      # Register stubs for current_value objects.
      #
      # @see #stubs_for_resource
      # @param target [String, nil] Resource name to inject, or nil for all resources.
      # @param block [Proc] A block taking the resource object as a parameter.
      # @return [void]
      def stubs_for_current_value(target=nil, &block)
        _chefspec_stubs_for_registry[:current_value][target] << block
      end
      alias_method :stubs_for_current_resource, :stubs_for_current_value

      # Register stubs for provider objects.
      #
      # @see #stubs_for_resource
      # @param target [String, nil] Resource name to inject, or nil for all providers.
      # @param block [Proc] A block taking the resource object as a parameter.
      # @return [void]
      def stubs_for_provider(target=nil, &block)
        _chefspec_stubs_for_registry[:provider][target] << block
      end

      def receive_shell_out(*cmd, stdout: '', stderr: '', exitstatus: 0, **opts)
        # Ruby does not allow constructing an actual exitstatus object from Ruby code. Really.
        fake_exitstatus = double(exitstatus: exitstatus)
        fake_cmd = Mixlib::ShellOut.new(*cmd)
        fake_cmd.define_singleton_method(:run_command) { } # Do nothing, just in case.
        # Inject our canned data.
        fake_cmd.instance_exec do
          @stdout = stdout
          @stderr = stderr
          @status = fake_exitstatus
        end
        # On newer Chef, we can intercept using the new, better shell_out_compact hook point.
        shell_out_method ||= if HAS_SHELLOUT_COMPACTED.satisfied_by?(Gem::Version.create(Chef::VERSION))
          :shell_out_compacted
        else
          :shell_out
        end
        with_args = cmd + (opts.empty? ? [any_args] : [hash_including(opts)])
        receive(shell_out_method).with(*with_args).and_return(fake_cmd)
      end

      module ClassMethods
        # (see StubsFor#stubs_for_resource)
        def stubs_for_resource(*args, &block)
          before { stubs_for_resource(*args, &block) }
        end

        # (see StubsFor#stubs_for_current_value)
        def stubs_for_current_value(*args, &block)
          before { stubs_for_current_value(*args, &block) }
        end
        alias_method :stubs_for_current_resource, :stubs_for_current_value

        # (see StubsFor#stubs_for_provider)
        def stubs_for_provider(*args, &block)
          before { stubs_for_provider(*args, &block) }
        end

        # @api private
        def included(klass)
          super
          # Inject classmethods into the group.
          klass.extend(ClassMethods)
        end
      end

      extend ClassMethods

    end
  end
end
