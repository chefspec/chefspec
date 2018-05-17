module ChefSpec
  module API
    module Described
      #
      # The name of the currently running cookbook spec. Given the top-level
      # +describe+ block is of the format:
      #
      #     describe 'my_cookbook::my_recipe' do
      #       # ...
      #     end
      #
      # The value of +described_cookbook+ is "my_cookbook".
      #
      # @example Using +described_cookbook+ in a context block
      #   context "#{described_recipe} installs foo" do
      #     # ...
      #   end
      #
      #
      # @return [String]
      #
      def described_cookbook
        described_recipe.split('::').first
      end

      #
      # The name of the currently running recipe spec. Given the top-level
      # +describe+ block is of the format:
      #
      #     describe 'my_cookbook::my_recipe' do
      #       # ...
      #     end
      #
      # The value of +described_recipe+ is "my_cookbook::my_recipe".
      #
      # @example Using +described_recipe+ in the +ChefSpec::SoloRunner+
      #   let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
      #
      #
      # @return [String]
      #
      def described_recipe
        scope = self.is_a?(Class) ? self : self.class

        metahash = scope.metadata
        while metahash.has_key?(:parent_example_group)
          metahash = metahash[:parent_example_group]
        end

        metahash[:description].to_s
      end

    end
  end
end
