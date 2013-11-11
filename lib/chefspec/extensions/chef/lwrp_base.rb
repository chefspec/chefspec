# Override Chef LWRP creation to remove existing class to avoid redefinition warnings.
class Chef
  module RemoveExistingLWRP
    def self.extended(klass)
      class << klass
        alias_method :old_build_from_file, :build_from_file
        remove_method :build_from_file
      end
    end

    #
    # Override Opscode provider to remove any existing LWRPs to suppress
    # constant re-definition warnings.
    #
    # @param [String] cookbook_name
    #   the name of the cookbook
    # @param [String] filename
    #   file to load as a LWRP
    # @param [Chef::RunContext] run_context
    #   context of a Chef Run
    #
    # @return [Chef::Provider]
    #
    def build_from_file(cookbook_name, filename, run_context)
      provider_name = filename_to_qualified_string(cookbook_name, filename)
      class_name    = convert_to_class_name(provider_name)

      remove_existing_lwrp(class_name)
      old_build_from_file(cookbook_name, filename, run_context)
    end

    #
    # Remove any existing Chef provider or resource with the specified name.
    #
    # @param [String] class_name
    #   The class name. Must be a valid constant name.
    #
    def remove_existing_lwrp(class_name)
      [self, superclass].each do |resource_holder|
        if resource_holder.const_defined? class_name, false
          resource_holder.send(:remove_const, class_name)
        end
      end
    end
  end

  class Provider
    # Chef provider for a resource
    class LWRPBase < Provider
      extend RemoveExistingLWRP

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

  class Resource
    # Chef provider for a resource
    class LWRPBase < Resource
      extend RemoveExistingLWRP
    end
  end
end
