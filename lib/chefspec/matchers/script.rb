require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    %w(bash csh perl python ruby).each do |interpreter|
      RSpec::Matchers.define "execute_#{interpreter}_script".to_sym do |name|
        match do |chef_run|
          chef_run.resources.any? do |resource|
            (resource_type(resource) == interpreter ||
            (resource_type(resource) == 'script' && resource.interpreter == interpreter)) &&
            resource.name == name
          end
        end
      end
    end
  end
end
