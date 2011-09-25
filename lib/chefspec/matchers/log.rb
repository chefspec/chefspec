require 'chefspec/matchers/shared'

module ChefSpec
  # RSpec Matchers
  module Matchers
    RSpec::Matchers.define :log do |message|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'log' and resource.name == message
        end
      end
    end
  end
end
