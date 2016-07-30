module ChefSpec::API
  # @since 3.0.0
  module AptRepositoryMatchers
    ChefSpec.define_matcher :apt_repository

    #
    # Assert that an +apt_repository+ resource exists in the Chef run with the
    # action +:add+. Given a Chef Recipe that adds "rsyslog" as an
    # +apt_repository+:
    #
    #     apt_repository 'rsyslog' do
    #       uri 'ppa:adiscon/v8-stable'
    #       action :add
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +apt_repository+ resource with ChefSpec.
    #
    # @example Assert that an +apt_repository+ was added
    #   expect(chef_run).to add_apt_repository('rsyslog')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def add_apt_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :add,
                                              resource_name)
    end

    #
    # Assert that an +apt_repository+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "rsyslog" as an
    # +apt_repository+:
    #
    #     apt_repository 'rsyslog' do
    #       uri 'ppa:adiscon/v8-stable'
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +apt_repository+ resource with ChefSpec.
    #
    # @example Assert that an +apt_repository+ was removed
    #   expect(chef_run).to remove_apt_repository('rsyslog')
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]

    def remove_apt_repository(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:apt_repository, :remove,
                                              resource_name)
    end
  end
end
