require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :execute_command do |command|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'execute' and resource.command == command
        end
      end
    end
  end
end
