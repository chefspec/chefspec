# Override Chef LWRP creation to remove existing class to avoid redefinition warnings.
class Chef
  class Provider
    class LWRPBase < Provider
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
  end
end
