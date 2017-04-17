if defined?(Chef::Provider::LWRPBase::InlineResources) # < 12.5
  class Chef
    class Provider
      class LWRPBase < Provider
        module InlineResources
          module ClassMethods
            def action(name, &block)
              define_method("action_#{name}", &block)
            end
          end
        end
      end
    end
  end
elsif defined?(Chef::Provider::InlineResources) # ~> 12.5
  class Chef
    class Provider
      module InlineResources
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
