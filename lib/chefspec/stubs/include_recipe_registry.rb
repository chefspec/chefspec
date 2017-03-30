require_relative 'registry'

module ChefSpec
  module Stubs
    class IncludeRecipeRegistry < Registry
      def stub_for(recipe)
        @stubs.find do |stub|
          stub.recipe.to_s == recipe.to_s
        end
      end
    end
  end
end
