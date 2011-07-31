require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    define_resource_matchers([:install, :remove, :upgrade, :purge], [:package], :package_name)

    RSpec::Matchers.define :install_package_at_version do |package_name, version|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'package' and resource.package_name == package_name and resource.action.to_s == 'install' and resource.version == version
        end
      end
    end
  end
end