require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    define_resource_matchers([:start, :stop, :restart, :reload, :nothing, :enable, :disable], [:service], :service_name)

    RSpec::Matchers.define :set_service_to_start_on_boot do |service|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'service' and resource.service_name == service and resource.action.include? :enable
        end
      end
    end
  end
end
