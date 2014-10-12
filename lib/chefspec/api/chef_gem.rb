module ChefSpec::API
  # @since 0.8.0
  module ChefGemMatchers
    ChefSpec.define_matcher :chef_gem

    #
    # Assert that a +chef_gem+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "community-zero" as a
    # +chef_gem+:
    #
    #     chef_gem 'community-zero' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chef_gem+ resource with ChefSpec.
    #
    # @example Assert that a +chef_gem+ was installed
    #   expect(chef_run).to install_chef_gem('community-zero')
    #
    # @example Assert that a +chef_gem+ was installed with predicate matchers
    #   expect(chef_run).to install_chef_gem('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +chef_gem+ was installed with attributes
    #   expect(chef_run).to install_chef_gem('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +chef_gem+ was installed using a regex
    #   expect(chef_run).to install_chef_gem('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +chef_gem+ was _not_ installed
    #   expect(chef_run).to_not install_chef_gem('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_chef_gem(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chef_gem, :install, resource_name)
    end

    #
    # Assert that a +chef_gem+ resource exists in the Chef run with the
    # action +:purge+. Given a Chef Recipe that purges "community-zero" as a
    # +chef_gem+:
    #
    #     chef_gem 'community-zero' do
    #       action :purge
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chef_gem+ resource with ChefSpec.
    #
    # @example Assert that a +chef_gem+ was purgeed
    #   expect(chef_run).to purge_chef_gem('community-zero')
    #
    # @example Assert that a +chef_gem+ was purgeed with predicate matchers
    #   expect(chef_run).to purge_chef_gem('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +chef_gem+ was purgeed with attributes
    #   expect(chef_run).to purge_chef_gem('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +chef_gem+ was purgeed using a regex
    #   expect(chef_run).to purge_chef_gem('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +chef_gem+ was _not_ purgeed
    #   expect(chef_run).to_not purge_chef_gem('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def purge_chef_gem(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chef_gem, :purge, resource_name)
    end

    #
    # Assert that a +chef_gem+ resource exists in the Chef run with the
    # action +:reconfig+. Given a Chef Recipe that reconfigures "community-zero"
    # as a +chef_gem+:
    #
    #     chef_gem 'community-zero' do
    #       action :reconfig
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chef_gem+ resource with ChefSpec.
    #
    # @example Assert that a +chef_gem+ was reconfigured
    #   expect(chef_run).to reconfig_chef_gem('community-zero')
    #
    # @example Assert that a +chef_gem+ was reconfigured with predicate matchers
    #   expect(chef_run).to reconfig_chef_gem('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +chef_gem+ was reconfigured with attributes
    #   expect(chef_run).to reconfig_chef_gem('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +chef_gem+ was reconfigured using a regex
    #   expect(chef_run).to reconfig_chef_gem('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +chef_gem+ was _not_ reconfigured
    #   expect(chef_run).to_not reconfig_chef_gem('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def reconfig_chef_gem(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chef_gem, :reconfig, resource_name)
    end

    #
    # Assert that a +chef_gem+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "community-zero" as a
    # +chef_gem+:
    #
    #     chef_gem 'community-zero' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chef_gem+ resource with ChefSpec.
    #
    # @example Assert that a +chef_gem+ was removeed
    #   expect(chef_run).to remove_chef_gem('community-zero')
    #
    # @example Assert that a +chef_gem+ was removeed with predicate matchers
    #   expect(chef_run).to remove_chef_gem('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +chef_gem+ was removeed with attributes
    #   expect(chef_run).to remove_chef_gem('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +chef_gem+ was removeed using a regex
    #   expect(chef_run).to remove_chef_gem('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +chef_gem+ was _not_ removeed
    #   expect(chef_run).to_not remove_chef_gem('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_chef_gem(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chef_gem, :remove, resource_name)
    end

    #
    # Assert that a +chef_gem+ resource exists in the Chef run with the
    # action +:upgrade+. Given a Chef Recipe that upgrades "community-zero" as a
    # +chef_gem+:
    #
    #     chef_gem 'community-zero' do
    #       action :upgrade
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chef_gem+ resource with ChefSpec.
    #
    # @example Assert that a +chef_gem+ was upgradeed
    #   expect(chef_run).to upgrade_chef_gem('community-zero')
    #
    # @example Assert that a +chef_gem+ was upgradeed with predicate matchers
    #   expect(chef_run).to upgrade_chef_gem('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +chef_gem+ was upgradeed with attributes
    #   expect(chef_run).to upgrade_chef_gem('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +chef_gem+ was upgradeed using a regex
    #   expect(chef_run).to upgrade_chef_gem('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +chef_gem+ was _not_ upgradeed
    #   expect(chef_run).to_not upgrade_chef_gem('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def upgrade_chef_gem(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chef_gem, :upgrade, resource_name)
    end
  end
end
