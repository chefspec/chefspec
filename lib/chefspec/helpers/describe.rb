module ChefSpec
  module Helpers
    module Describe
      def described_recipe
        self.class.metadata[:example_group][:description_args].first
      end

      def described_cookbook
        described_recipe.split('::').first
      end
    end
  end
end
