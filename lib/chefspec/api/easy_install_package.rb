module ChefSpec::API
  # @since 3.0.0
  module EasyInstallPackageMatchers
    ChefSpec.define_matcher :easy_install_package

    #
    # Assert that an +easy_install_package+ resource exists in the Chef run
    # with the action +:install+. Given a Chef Recipe that installs "pygments" as a
    # +easy_install_package+:
    #
    #     easy_install_package 'pygments' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +easy_install_package+ resource with ChefSpec.
    #
    # @example Assert that an +easy_install_package+ was installed
    #   expect(chef_run).to install_easy_install_package('pygments')
    #
    # @example Assert that an +easy_install_package+ was installed with predicate matchers
    #   expect(chef_run).to install_easy_install_package('pygments').with_version('1.2.3')
    #
    # @example Assert that an +easy_install_package+ was installed with attributes
    #   expect(chef_run).to install_easy_install_package('pygments').with(version: '1.2.3')
    #
    # @example Assert that an +easy_install_package+ was installed using a regex
    #   expect(chef_run).to install_easy_install_package('pygments').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +easy_install_package+ was _not_ installed
    #   expect(chef_run).to_not install_easy_install_package('pygments')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_easy_install_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:easy_install_package, :install, resource_name)
    end

    #
    # Assert that an +easy_install_package+ resource exists in the Chef run
    # with the action +:purge+. Given a Chef Recipe that purges "pygments" as a
    # +easy_install_package+:
    #
    #     easy_install_package 'pygments' do
    #       action :purge
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +easy_install_package+ resource with ChefSpec.
    #
    # @example Assert that an +easy_install_package+ was purged
    #   expect(chef_run).to purge_easy_install_package('pygments')
    #
    # @example Assert that an +easy_install_package+ was purged with predicate matchers
    #   expect(chef_run).to purge_easy_install_package('pygments').with_version('1.2.3')
    #
    # @example Assert that an +easy_install_package+ was purged with attributes
    #   expect(chef_run).to purge_easy_install_package('pygments').with(version: '1.2.3')
    #
    # @example Assert that an +easy_install_package+ was purged using a regex
    #   expect(chef_run).to purge_easy_install_package('pygments').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +easy_install_package+ was _not_ purged
    #   expect(chef_run).to_not purge_easy_install_package('pygments')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def purge_easy_install_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:easy_install_package, :purge, resource_name)
    end

    #
    # Assert that an +easy_install_package+ resource exists in the Chef run
    # with the action +:remove+. Given a Chef Recipe that removes "pygments" as a
    # +easy_install_package+:
    #
    #     easy_install_package 'pygments' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +easy_install_package+ resource with ChefSpec.
    #
    # @example Assert that an +easy_install_package+ was removed
    #   expect(chef_run).to remove_easy_install_package('pygments')
    #
    # @example Assert that an +easy_install_package+ was removed with predicate matchers
    #   expect(chef_run).to remove_easy_install_package('pygments').with_version('1.2.3')
    #
    # @example Assert that an +easy_install_package+ was removed with attributes
    #   expect(chef_run).to remove_easy_install_package('pygments').with(version: '1.2.3')
    #
    # @example Assert that an +easy_install_package+ was removed using a regex
    #   expect(chef_run).to remove_easy_install_package('pygments').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +easy_install_package+ was _not_ removed
    #   expect(chef_run).to_not remove_easy_install_package('pygments')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_easy_install_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:easy_install_package, :remove, resource_name)
    end

    #
    # Assert that an +easy_install_package+ resource exists in the Chef run
    # with the action +:upgrade+. Given a Chef Recipe that upgrades "pygments" as a
    # +easy_install_package+:
    #
    #     easy_install_package 'pygments' do
    #       action :upgrade
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +easy_install_package+ resource with ChefSpec.
    #
    # @example Assert that an +easy_install_package+ was upgraded
    #   expect(chef_run).to upgrade_easy_install_package('pygments')
    #
    # @example Assert that an +easy_install_package+ was upgraded with predicate matchers
    #   expect(chef_run).to upgrade_easy_install_package('pygments').with_version('1.2.3')
    #
    # @example Assert that an +easy_install_package+ was upgraded with attributes
    #   expect(chef_run).to upgrade_easy_install_package('pygments').with(version: '1.2.3')
    #
    # @example Assert that an +easy_install_package+ was upgraded using a regex
    #   expect(chef_run).to upgrade_easy_install_package('pygments').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that an +easy_install_package+ was _not_ upgraded
    #   expect(chef_run).to_not upgrade_easy_install_package('pygments')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def upgrade_easy_install_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:easy_install_package, :upgrade, resource_name)
    end
  end
end
