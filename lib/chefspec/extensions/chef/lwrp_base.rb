# XXX: This monkeypatch is somewhat terrible and dumps all of the
# resources in the sub-resource collection into the main resource
# collection.  Chefspec needs to be taught how to deal with
# sub-resource collections.

if defined?(Chef::Provider::InlineResources)
  class Chef
    class Provider
      module InlineResources # ~> 12.5
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
else # >= 13.0
  class Chef
    class Provider
      def self.action(name, &block)
        define_method("action_#{name}", &block)
      end
    end
  end
end
