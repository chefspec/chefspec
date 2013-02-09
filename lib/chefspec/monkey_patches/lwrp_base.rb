if Chef::VERSION >= '11.0.0'

  # Override Chef LWRP creation to remove existing class to avoid redefinition warnings.
  class Chef
    class Provider
      # Chef provider for a resource
      class LWRPBase < Provider
        class << self
          alias_method :old_build_from_file, :build_from_file

          # Override Opscode provider to remove any existing LWRP
          #
          # @param [String] cookbook_name The name of the cookbook
          # @param [String] filename File to load as a LWRP
          # @param [Chef::RunContext] run_context Context of a Chef Run
          # @return [Chef::Provider] the created provider
          def build_from_file(*args)
            cookbook_name, filename = args[0,2]
            remove_existing_lwrp(convert_to_class_name(filename_to_qualified_string(cookbook_name, filename)))
            old_build_from_file(*args)
          end

          # Remove any existing Chef provider or resource with the specified name.
          #
          # @param [String] class_name The class name. Must be a valid constant name.
          def remove_existing_lwrp(class_name)
            [Chef::Resource::LWRPBase, Chef::Provider::LWRPBase].each do |resource_holder|
              if RUBY_VERSION < '1.9'
                if resource_holder.const_defined? class_name
                  resource_holder.send(:remove_const, class_name)
                end
              else
                if resource_holder.const_defined? class_name, false
                  resource_holder.send(:remove_const, class_name)
                end
              end
            end
          end

        end
      end
    end

  end
end
