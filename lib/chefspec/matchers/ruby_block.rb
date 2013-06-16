require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :execute_ruby_block do |block_name|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'ruby_block' and block_name === resource.name
        end
      end
    end
  end
end
