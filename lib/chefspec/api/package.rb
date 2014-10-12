module ChefSpec::API
  # @since 0.0.1
  module PackageMatchers
    ChefSpec.define_matcher :package

    #
    # Assert that an +package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "apache2" as an
    # +package+:
    #
    #     package 'apache2' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +package+ resource with ChefSpec.
    #
    # @example Assert that an +package+ was installed
    #   expect(chef_run).to install_package('apache2')
    #
    # @example Assert that an +package+ was installed with predicate matchers
    #   expect(chef_run).to install_package('apache2').with_version('1.2.3')
    #
    # @example Assert that an +package+ was installed with attributes
    #   expect(chef_run).to install_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that an +package+ was installed using a regex
    #   expect(chef_run).to install_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +package+ was _not_ installed
    #   expect(chef_run).to_not install_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:package, :install, resource_name)
    end

    #
    # Assert that an +package+ resource exists in the Chef run with the
    # action +:purge+. Given a Chef Recipe that purges "apache2" as an
    # +package+:
    #
    #     package 'apache2' do
    #       action :purge
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +package+ resource with ChefSpec.
    #
    # @example Assert that an +package+ was purged
    #   expect(chef_run).to purge_package('apache2')
    #
    # @example Assert that an +package+ was purged with predicate matchers
    #   expect(chef_run).to purge_package('apache2').with_version('1.2.3')
    #
    # @example Assert that an +package+ was purged with attributes
    #   expect(chef_run).to purge_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that an +package+ was purged using a regex
    #   expect(chef_run).to purge_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +package+ was _not_ purged
    #   expect(chef_run).to_not purge_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def purge_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:package, :purge, resource_name)
    end

    #
    # Assert that an +package+ resource exists in the Chef run with the
    # action +:reconfig+. Given a Chef Recipe that reconfigures "apache2" as an
    # +package+:
    #
    #     package 'apache2' do
    #       action :reconfig
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +package+ resource with ChefSpec.
    #
    # @example Assert that an +package+ was reconfigured
    #   expect(chef_run).to reconfig_package('apache2')
    #
    # @example Assert that an +package+ was reconfigured with predicate matchers
    #   expect(chef_run).to reconfig_package('apache2').with_version('1.2.3')
    #
    # @example Assert that an +package+ was reconfigured with attributes
    #   expect(chef_run).to reconfig_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that an +package+ was reconfigured using a regex
    #   expect(chef_run).to reconfig_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +package+ was _not_ reconfigured
    #   expect(chef_run).to_not reconfig_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def reconfig_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:package, :reconfig, resource_name)
    end

    #
    # Assert that an +package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "apache2" as an
    # +package+:
    #
    #     package 'apache2' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +package+ resource with ChefSpec.
    #
    # @example Assert that an +package+ was removed
    #   expect(chef_run).to remove_package('apache2')
    #
    # @example Assert that an +package+ was removed with predicate matchers
    #   expect(chef_run).to remove_package('apache2').with_version('1.2.3')
    #
    # @example Assert that an +package+ was removed with attributes
    #   expect(chef_run).to remove_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that an +package+ was removed using a regex
    #   expect(chef_run).to remove_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +package+ was _not_ removed
    #   expect(chef_run).to_not remove_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:package, :remove, resource_name)
    end

    #
    # Assert that an +package+ resource exists in the Chef run with the
    # action +:upgrade+. Given a Chef Recipe that upgrades "apache2" as an
    # +package+:
    #
    #     package 'apache2' do
    #       action :upgrade
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +package+ resource with ChefSpec.
    #
    # @example Assert that an +package+ was upgraded
    #   expect(chef_run).to upgrade_package('apache2')
    #
    # @example Assert that an +package+ was upgraded with predicate matchers
    #   expect(chef_run).to upgrade_package('apache2').with_version('1.2.3')
    #
    # @example Assert that an +package+ was upgraded with attributes
    #   expect(chef_run).to upgrade_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that an +package+ was upgraded using a regex
    #   expect(chef_run).to upgrade_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +package+ was _not_ upgraded
    #   expect(chef_run).to_not upgrade_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def upgrade_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:package, :upgrade, resource_name)
    end

  end
end
