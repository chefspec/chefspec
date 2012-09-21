require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :include_recipe do |expected_recipe|
      match do |chef_run|
        actual_recipes = chef_run.node.run_state[:seen_recipes]
        actual_recipes.include?(expected_recipe)
      end

      failure_message_for_should do |chef_run|
        "expected: ['#{expected_recipe}']\n" +
        "     got: #{chef_run.node.run_state.recipes}"
      end
    end
  end
end
