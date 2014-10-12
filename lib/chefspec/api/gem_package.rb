module ChefSpec::API
  # @since 0.5.0
  module GemPackageMatchers
    ChefSpec.define_matcher :gem_package

    #
    # Assert that a +gem_package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "community-zero" as a
    # +gem_package+:
    #
    #     gem_package 'community-zero' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +gem_package+ resource with ChefSpec.
    #
    # @example Assert that a +gem_package+ was installed
    #   expect(chef_run).to install_gem_package('community-zero')
    #
    # @example Assert that a +gem_package+ was installed with predicate matchers
    #   expect(chef_run).to install_gem_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +gem_package+ was installed with attributes
    #   expect(chef_run).to install_gem_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +gem_package+ was installed using a regex
    #   expect(chef_run).to install_gem_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +gem_package+ was _not_ installed
    #   expect(chef_run).to_not install_gem_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_gem_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:gem_package, :install, resource_name)
    end

    #
    # Assert that a +gem_package+ resource exists in the Chef run with the
    # action +:purge+. Given a Chef Recipe that purges "community-zero" as a
    # +gem_package+:
    #
    #     gem_package 'community-zero' do
    #       action :purge
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +gem_package+ resource with ChefSpec.
    #
    # @example Assert that a +gem_package+ was purgeed
    #   expect(chef_run).to purge_gem_package('community-zero')
    #
    # @example Assert that a +gem_package+ was purgeed with predicate matchers
    #   expect(chef_run).to purge_gem_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +gem_package+ was purgeed with attributes
    #   expect(chef_run).to purge_gem_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +gem_package+ was purgeed using a regex
    #   expect(chef_run).to purge_gem_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +gem_package+ was _not_ purgeed
    #   expect(chef_run).to_not purge_gem_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def purge_gem_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:gem_package, :purge, resource_name)
    end

    #
    # Assert that a +gem_package+ resource exists in the Chef run with the
    # action +:reconfig+. Given a Chef Recipe that reconfigures "community-zero"
    # as a +gem_package+:
    #
    #     gem_package 'community-zero' do
    #       action :reconfig
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +gem_package+ resource with ChefSpec.
    #
    # @example Assert that a +gem_package+ was reconfigured
    #   expect(chef_run).to reconfig_gem_package('community-zero')
    #
    # @example Assert that a +gem_package+ was reconfigured with predicate matchers
    #   expect(chef_run).to reconfig_gem_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +gem_package+ was reconfigured with attributes
    #   expect(chef_run).to reconfig_gem_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +gem_package+ was reconfigured using a regex
    #   expect(chef_run).to reconfig_gem_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +gem_package+ was _not_ reconfigured
    #   expect(chef_run).to_not reconfig_gem_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def reconfig_gem_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:gem_package, :reconfig, resource_name)
    end

    #
    # Assert that a +gem_package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "community-zero" as a
    # +gem_package+:
    #
    #     gem_package 'community-zero' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +gem_package+ resource with ChefSpec.
    #
    # @example Assert that a +gem_package+ was removeed
    #   expect(chef_run).to remove_gem_package('community-zero')
    #
    # @example Assert that a +gem_package+ was removeed with predicate matchers
    #   expect(chef_run).to remove_gem_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +gem_package+ was removeed with attributes
    #   expect(chef_run).to remove_gem_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +gem_package+ was removeed using a regex
    #   expect(chef_run).to remove_gem_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +gem_package+ was _not_ removeed
    #   expect(chef_run).to_not remove_gem_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_gem_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:gem_package, :remove, resource_name)
    end

    #
    # Assert that a +gem_package+ resource exists in the Chef run with the
    # action +:upgrade+. Given a Chef Recipe that upgrades "community-zero" as a
    # +gem_package+:
    #
    #     gem_package 'community-zero' do
    #       action :upgrade
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +gem_package+ resource with ChefSpec.
    #
    # @example Assert that a +gem_package+ was upgradeed
    #   expect(chef_run).to upgrade_gem_package('community-zero')
    #
    # @example Assert that a +gem_package+ was upgradeed with predicate matchers
    #   expect(chef_run).to upgrade_gem_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +gem_package+ was upgradeed with attributes
    #   expect(chef_run).to upgrade_gem_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +gem_package+ was upgradeed using a regex
    #   expect(chef_run).to upgrade_gem_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +gem_package+ was _not_ upgradeed
    #   expect(chef_run).to_not upgrade_gem_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def upgrade_gem_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:gem_package, :upgrade, resource_name)
    end
  end
end
