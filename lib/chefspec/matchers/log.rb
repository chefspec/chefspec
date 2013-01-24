require 'chefspec/matchers/shared'

module ChefSpec
  # RSpec Matchers
  module Matchers
    RSpec::Matchers.define :log do |message|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          if resource_type(resource) != 'log'
            false
          elsif resource.respond_to?(:message)
            # Chef 10.18 added message attribute to the log resource
            resource.message == message
          else
            resource.name == message
          end
        end
      end
    end
  end
end
