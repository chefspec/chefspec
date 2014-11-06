#
# This file contains the backwards compatible hacks required to make ChefSpec
# work with the previous version of Chef. ChefSpec only promises to be backwards
# compatible with the last major release of Chef, but it may work with earlier
# versions.
#
# The hacks are kept in this file so as to avoid a bunch of branching logic
# throughout the codebase. It also makes dropping backwards compatability much
# easier without the risk of breaking things.
#
# This file must be loaded AFTER the rest of ChefSpec has been initialized!
#

module ChefSpec
  class ServerRunner
    #
    # The method airty for the Chef::CookbookUploader used to accept a list of
    # cookbook paths. This restores that behavior.
    #
    def cookbook_uploader_for(loader)
      Chef::CookbookUploader.new(loader.cookbooks, loader.cookbook_paths)
    end
  end

  module RemoveExistingLWRP
    def self.extended(klass)
      class << klass
        alias_method :build_from_file_without_removal, :build_from_file
        alias_method :build_from_file, :build_from_file_with_removal
      end
    end

    #
    # Override Chef provider to remove any existing LWRPs to suppress constant
    # re-definition warnings.
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
    def build_from_file_with_removal(cookbook_name, filename, run_context)
      provider_name = filename_to_qualified_string(cookbook_name, filename)
      class_name    = convert_to_class_name(provider_name)

      remove_existing_lwrp(class_name)
      build_from_file_without_removal(cookbook_name, filename, run_context)
    end

    #
    # Remove any existing Chef provider or resource with the specified name.
    #
    # @param [String] class_name
    #   The class name. Must be a valid constant name.
    #
    def remove_existing_lwrp(class_name)
      [self, superclass].each do |resource_holder|
        look_in_parents = false
        if resource_holder.const_defined?(class_name, look_in_parents)
          old_class = resource_holder.send(:remove_const, class_name)

          if resource_holder.respond_to?(:resource_classes)
            resource_holder.resource_classes.delete(old_class)
          end
        end
      end
    end
  end
end


# Only remove existing LWRPs for older versions of Chef. Newer versions of
# Chef do not break things as much...
Chef::Provider::LWRPBase.extend(ChefSpec::RemoveExistingLWRP)
Chef::Resource::LWRPBase.extend(ChefSpec::RemoveExistingLWRP)
