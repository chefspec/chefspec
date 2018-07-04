module ChefSpec
  module API
    module DoNothing
      #
      # Assert that a resource in the Chef run does not perform any actions. Given
      # a resource with +action :nothing+:
      #
      #     package 'apache2' do
      #       action :nothing
      #     end
      #
      # The Examples section demonstrates the different ways to test that no
      # actions were performed on a resource in a Chef run.
      #
      # @example Assert the +package+ does not perform any actions
      #   expect(chef_run.package('apache2')).to do_nothing
      #
      # @return [ChefSpec::Matchers::DoNothingMatcher]
      #
      def do_nothing
        ChefSpec::Matchers::DoNothingMatcher.new
      end

    end
  end
end
