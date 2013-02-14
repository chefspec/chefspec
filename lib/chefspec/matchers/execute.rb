require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :execute_command do |command|
      match do |chef_run|
        if @attributes
          chef_run.resources.any? do |resource|
            resource_type(resource) == 'execute' &&
              resource.command == command &&
              @attributes.all? { |k,v| resource.send(k) == v }
          end
        else
          chef_run.resources.any? do |resource|
            resource_type(resource) == 'execute' &&
              resource.command == command
          end
        end
      end

      chain :with do |attributes|
        @attributes = attributes
      end
    end
  end
end
