module ChefSpec::API
  # @since 3.0.0
  module AptUpdateMatchers
    ChefSpec.define_matcher :apt_update

    #
    # Assert that an +apt_update+ resource exists in the Chef run with the
    # action +:update+. Given a Chef Recipe that adds "rsyslog" as a repository
    # to update.
    #     apt_repository 'rsyslog' do
    #       action :update
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +apt_update+ resource with ChefSpec.
    #
    # @example Assert that an +apt_update+ was run
    #   expect(chef_run).to update_apt_update('rsyslog')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def update_apt_update(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:apt_update, :update,
                                              resource_name)
    end

    #
    # Assert that an +apt_update+ resource exists in the Chef run
    # with the action +:periodic+. Given a Chef Recipe that updates "rsyslog"
    # as an +apt_update+: periodically
    #
    #     apt_update 'rsyslog' do
    #       action :periodic
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +apt_update+ resource with ChefSpec.
    #
    # @example Assert that an +apt_update+ was updated periodically
    #   expect(chef_run).to periodic_apt_update('rsyslog')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def periodic_apt_update(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:apt_update, :periodic,
                                              resource_name)
    end
  end
end
