require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    CHEF_GEM_SUPPORTED = defined?(::Chef::Resource::ChefGem)
    PACKAGE_TYPES = [:package, :gem_package, :chef_gem]
    PACKAGE_TYPES << :chef_gem if CHEF_GEM_SUPPORTED
    define_resource_matchers([:install, :remove, :upgrade, :purge], PACKAGE_TYPES, :package_name)

    RSpec::Matchers.define :install_package_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) == 'package' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
        end
      end
    end
    RSpec::Matchers.define :install_gem_package_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) == 'gem_package' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
        end
      end
    end
    RSpec::Matchers.define :install_chef_gem_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) == 'chef_gem' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
        end
      end
    end if CHEF_GEM_SUPPORTED
  end
end
