# Override Chef LWRP creation to remove existing class to avoid redefinition warnings.
class Chef
  class Provider
    class LWRPBase < Provider
      # 12.4 version of inline resources
      module InlineResources
        module ClassMethods
          #
          # For LWRPs that call +use_inline_resources+, do not create another
          # +resource_collection+ so that everything is added to the parent
          # +resource_collection+.
          #
          # @param [String] name
          #
          # @override Chef::Provider::LWRPBase::InlineResources::ClassMethods#action
          #
          def action(name, &block)
            define_method("action_#{name}", &block)
          end
        end
      end
    end

    # 12.5 version of inline resources
    module InlineResources
      #
      # For LWRPs that call +use_inline_resources+, do not create another
      # +resource_collection+ so that everything is added to the parent
      # +resource_collection+.
      #
      # @param [String] name
      #
      def initialize(resource, run_context)
        super
        @run_context = run_context
        @resource_collection = run_context.resource_collection
      end

      module ClassMethods
        def action(name, &block)
          define_method("action_#{name}", &block)
        end
      end
    end
  end
end
