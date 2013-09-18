require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:install, :remove, :upgrade, :purge], ChefSpec::ChefRunner::PACKAGE_RESOURCES, :package_name)

    %w{package yum_package gem_package chef_gem windows_package}.each do |resource_name|
      RSpec::Matchers.define "install_#{resource_name}_at_version".to_sym do |package_name, version|
        match do |chef_run|
          chef_run.resources.any? do |resource|
            resource_type(resource) == resource_name and resource.package_name == package_name and resource.action.to_s.include? 'install' and resource.version == version
          end
        end
      end
    end
  end
end
