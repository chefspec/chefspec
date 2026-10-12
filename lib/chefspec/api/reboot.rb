module ChefSpec
  module API
    #
    # Matchers for the +reboot+ resource, whose actions do not follow the usual naming pattern.
    #
    # Mixed into every example group by {ChefSpec::API.included}.
    #
    module Reboot
      #
      # Assert that a +reboot+ resource performed the +:reboot_now+ action.
      #
      # @example
      #   expect(chef_run).to now_reboot("app server")
      #
      # @param [String] resource_name
      #   the name of the reboot resource
      #
      # @return [ChefSpec::Matchers::ResourceMatcher]
      #
      def now_reboot(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:reboot, :reboot_now, resource_name)
      end

      #
      # Assert that a +reboot+ resource performed the +:request_reboot+ action.
      #
      # @example
      #   expect(chef_run).to request_reboot("app server")
      #
      # @param [String] resource_name
      #   the name of the reboot resource
      #
      # @return [ChefSpec::Matchers::ResourceMatcher]
      #
      def request_reboot(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:reboot, :request_reboot, resource_name)
      end

    end
  end
end
