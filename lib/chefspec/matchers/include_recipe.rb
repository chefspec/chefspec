require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :include_recipe do |expected_recipe|
      match do |chef_run|
        if chef_run.run_context.respond_to?(:loaded_recipe?)
          chef_run.run_context.loaded_recipe?(expected_recipe) # Chef 11+
        else
          chef_run.node.run_state[:seen_recipes].include?(expected_recipe) # Chef 10 and lower
        end
      end

      failure_message_for_should do |chef_run|
        "expected: ['#{expected_recipe}']\n" +
        "     got: #{chef_run.run_context.respond_to?(:loaded_recipes) ? chef_run.run_context.loaded_recipes : chef_run.node.run_state[:seen_recipes]}"
      end
    end
  end
end
