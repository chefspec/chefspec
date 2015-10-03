module ChefSpec::API
  # @since 3.0.0
  module RouteMatchers
    ChefSpec.define_matcher :route

    #
    # Assert that a +route+ resource exists in the Chef run with the
    # action +:add+. Given a Chef Recipe that adds "10.0.0.10/32" as a
    # +route+:
    #
    #     route '10.0.0.10/32' do
    #       action :add
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +route+ resource with ChefSpec.
    #
    # @example Assert that a +route+ was added
    #   expect(chef_run).to add_route('10.0.0.10/32')
    #
    # @example Assert that a +route+ was added with predicate matchers
    #   expect(chef_run).to add_route('10.0.0.10/32').with_device('eth0')
    #
    # @example Assert that a +route+ was added with attributes
    #   expect(chef_run).to add_route('10.0.0.10/32').with(device: 'eth0')
    #
    # @example Assert that a +route+ was added using a regex
    #   expect(chef_run).to add_route('10.0.0.10/32').with(device: /eth(\d+)/)
    #
    # @example Assert that a +route+ was _not_ added
    #   expect(chef_run).to_not add_route('10.0.0.10/32')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def add_route(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:route, :add, resource_name)
    end

    #
    # Assert that a +route+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "10.0.0.10/32" as a
    # +route+:
    #
    #     route '10.0.0.10/32' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +route+ resource with ChefSpec.
    #
    # @example Assert that a +route+ was deleted
    #   expect(chef_run).to delete_route('10.0.0.10/32')
    #
    # @example Assert that a +route+ was deleted with predicate matchers
    #   expect(chef_run).to delete_route('10.0.0.10/32').with_device('eth0')
    #
    # @example Assert that a +route+ was deleted with attributes
    #   expect(chef_run).to delete_route('10.0.0.10/32').with(device: 'eth0')
    #
    # @example Assert that a +route+ was deleted using a regex
    #   expect(chef_run).to delete_route('10.0.0.10/32').with(device: /eth(\d+)/)
    #
    # @example Assert that a +route+ was _not_ deleted
    #   expect(chef_run).to_not delete_route('10.0.0.10/32')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_route(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:route, :delete, resource_name)
    end
  end
end
