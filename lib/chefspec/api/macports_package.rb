module ChefSpec::API
  # @since 3.0.0
  module MacportsPackageMatchers
    ChefSpec.define_matcher :macports_package

    #
    # Assert that a +macports_package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "community-zero" as a
    # +macports_package+:
    #
    #     macports_package 'community-zero' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +macports_package+ resource with ChefSpec.
    #
    # @example Assert that a +macports_package+ was installed
    #   expect(chef_run).to install_macports_package('community-zero')
    #
    # @example Assert that a +macports_package+ was installed with predicate matchers
    #   expect(chef_run).to install_macports_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +macports_package+ was installed with attributes
    #   expect(chef_run).to install_macports_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +macports_package+ was installed using a regex
    #   expect(chef_run).to install_macports_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +macports_package+ was _not_ installed
    #   expect(chef_run).to_not install_macports_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_macports_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:macports_package, :install, resource_name)
    end

    #
    # Assert that a +macports_package+ resource exists in the Chef run with the
    # action +:purge+. Given a Chef Recipe that purges "community-zero" as a
    # +macports_package+:
    #
    #     macports_package 'community-zero' do
    #       action :purge
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +macports_package+ resource with ChefSpec.
    #
    # @example Assert that a +macports_package+ was purgeed
    #   expect(chef_run).to purge_macports_package('community-zero')
    #
    # @example Assert that a +macports_package+ was purgeed with predicate matchers
    #   expect(chef_run).to purge_macports_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +macports_package+ was purgeed with attributes
    #   expect(chef_run).to purge_macports_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +macports_package+ was purgeed using a regex
    #   expect(chef_run).to purge_macports_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +macports_package+ was _not_ purgeed
    #   expect(chef_run).to_not purge_macports_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def purge_macports_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:macports_package, :purge, resource_name)
    end

    #
    # Assert that a +macports_package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "community-zero" as a
    # +macports_package+:
    #
    #     macports_package 'community-zero' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +macports_package+ resource with ChefSpec.
    #
    # @example Assert that a +macports_package+ was removeed
    #   expect(chef_run).to remove_macports_package('community-zero')
    #
    # @example Assert that a +macports_package+ was removeed with predicate matchers
    #   expect(chef_run).to remove_macports_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +macports_package+ was removeed with attributes
    #   expect(chef_run).to remove_macports_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +macports_package+ was removeed using a regex
    #   expect(chef_run).to remove_macports_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +macports_package+ was _not_ removeed
    #   expect(chef_run).to_not remove_macports_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_macports_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:macports_package, :remove, resource_name)
    end

    #
    # Assert that a +macports_package+ resource exists in the Chef run with the
    # action +:upgrade+. Given a Chef Recipe that upgrades "community-zero" as a
    # +macports_package+:
    #
    #     macports_package 'community-zero' do
    #       action :upgrade
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +macports_package+ resource with ChefSpec.
    #
    # @example Assert that a +macports_package+ was upgradeed
    #   expect(chef_run).to upgrade_macports_package('community-zero')
    #
    # @example Assert that a +macports_package+ was upgradeed with predicate matchers
    #   expect(chef_run).to upgrade_macports_package('community-zero').with_version('1.2.3')
    #
    # @example Assert that a +macports_package+ was upgradeed with attributes
    #   expect(chef_run).to upgrade_macports_package('community-zero').with(version: '1.2.3')
    #
    # @example Assert that a +macports_package+ was upgradeed using a regex
    #   expect(chef_run).to upgrade_macports_package('community-zero').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +macports_package+ was _not_ upgradeed
    #   expect(chef_run).to_not upgrade_macports_package('community-zero')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def upgrade_macports_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:macports_package, :upgrade, resource_name)
    end
  end
end
