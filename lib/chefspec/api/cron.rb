module ChefSpec::API
  # @since 0.7.0
  module CronMatchers
    ChefSpec.define_matcher :cron

    #
    # Assert that a +cron+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "ping nagios" as a
    # +cron+:
    #
    #     cron 'ping nagios' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +cron+ resource with ChefSpec.
    #
    # @example Assert that a +cron+ was created
    #   expect(chef_run).to create_cron('ping nagios')
    #
    # @example Assert that a +cron+ was created with predicate matchers
    #   expect(chef_run).to create_cron('ping nagios').with_home('/home')
    #
    # @example Assert that a +cron+ was created with attributes
    #   expect(chef_run).to create_cron('ping nagios').with(home: '/home')
    #
    # @example Assert that a +cron+ was created using a regex
    #   expect(chef_run).to create_cron('ping nagios').with(home: /\/home/)
    #
    # @example Assert that a +cron+ was _not_ created
    #   expect(chef_run).to_not create_cron('ping nagios')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_cron(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:cron, :create, resource_name)
    end

    #
    # Assert that a +cron+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "ping nagios" as a
    # +cron+:
    #
    #     cron 'ping nagios' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +cron+ resource with ChefSpec.
    #
    # @example Assert that a +cron+ was deleted
    #   expect(chef_run).to delete_cron('ping nagios')
    #
    # @example Assert that a +cron+ was deleted with predicate matchers
    #   expect(chef_run).to delete_cron('ping nagios').with_home('/home')
    #
    # @example Assert that a +cron+ was deleted with attributes
    #   expect(chef_run).to delete_cron('ping nagios').with(home: '/home')
    #
    # @example Assert that a +cron+ was deleted using a regex
    #   expect(chef_run).to delete_cron('ping nagios').with(home: /\/home/)
    #
    # @example Assert that a +cron+ was _not_ deleted
    #   expect(chef_run).to_not delete_cron('ping nagios')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_cron(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:cron, :delete, resource_name)
    end
  end
end
