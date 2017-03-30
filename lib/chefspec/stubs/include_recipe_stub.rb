require_relative 'stub'

module ChefSpec
  module Stubs
    class IncludeRecipeStub < Stub
      attr_reader :recipe
      attr_reader :current_cookbook

      def initialize(recipe, described_cookbook = nil)
        @recipe = recipe
        @current_cookbook = described_cookbook
      end

      def signature
        "stub_include_recipe(#{@recipe.inspect})"
      end
    end
  end
end
