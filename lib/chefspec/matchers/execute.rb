require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :execute_command do |command|
      match do |chef_run|
        if @attributes
          chef_run.resources.any? do |resource|
            expected_resource?(resource,command) &&
              expected_attributes?(resource)
          end
        else
          chef_run.resources.any? do |resource|
            expected_resource?(resource,command)
          end
        end
      end

      chain :with do |attributes|
        @attributes = attributes
      end

      def expected_resource?(resource,command)
        resource_type(resource) == 'execute' &&
          resource.command == command
      end

      def expected_attributes?(resource)
        @attributes.all? { |k,v| resource.send(k) == v }
      end
    end
  end
end
