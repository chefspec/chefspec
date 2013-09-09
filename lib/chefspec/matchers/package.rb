require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:install, :remove, :upgrade, :purge], [:package, :gem_package, :chef_gem, :yum_package], :package_name)

    RSpec::Matchers.define :install_package_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) == 'package' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
        end
      end
    end

    RSpec::Matchers.define :install_yum_package_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) == 'yum_package' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
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
    end

    define_resource_matchers([:install, :remove], [:windows_package], :package_name)
    RSpec::Matchers.define :install_windows_package_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) === 'windows_package' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
        end
      end
    end
  end
end

module ChefSpec
  module Matchers
    define_resource_matchers([:install, :remove], [:windows_package], :package_name)

    RSpec::Matchers.define :install_windows_package_at_version do |package_name, version|
      match do |chef_run|
       chef_run.resources.any? do |resource|
          resource_type(resource) === 'windows_package' and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
        end
      end
    end
  end
end
