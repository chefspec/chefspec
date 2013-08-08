module ChefSpec
  module Helpers
    module Describe
      def described_recipe
        metahash = self.class.metadata
        while metahash.has_key? :example_group
          metahash = metahash[:example_group]
        end
        metahash[:description_args].first
      end

      def described_cookbook
        described_recipe.split('::').first
      end
    end
  end
end
