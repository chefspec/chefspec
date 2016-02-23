module ChefSpec::API
  # @since 4.6.0
  module ChocolateyPackageMatchers
    ChefSpec.define_matcher :chocolatey_package
    #
    # Assert that a +chocolatey_package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "7zip" as a
    # +chocolatey_package+:
    #
    #     chocolatey_package '7zip' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chocolatey_package+ resource with ChefSpec.
    #
    # @example Assert that a +chocolatey_package+ was installed
    #   expect(chef_run).to install_chocolatey_package('7zip')
    #
    # @example Assert that a +chocolatey_package+ was installed with attributes
    #   expect(chef_run).to install_chocolatey_package('git').with(
    #     version: %w(2.7.1),
    #     options: '--params /GitAndUnixToolsOnPath'
    #  )
    #
    # @example Assert that a +chocolatey_package+ was _not_ installed
    #   expect(chef_run).to_not install_chocolatey_package('flashplayeractivex')
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_chocolatey_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chocolatey_package, :install, resource_name)
    end

    #
    # Assert that a +chocolatey_package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "7zip" as a
    # +chocolatey_package+:
    #
    #     chocolatey_package '7zip' do
    #       action :remove
    #     end
    #
    # To test the content rendered by a +chocolatey_package+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +chocolatey_package+ resource with ChefSpec.
    #
    # @example Assert that a +chocolatey_package+ was removed
    #   expect(chef_run).to remove_chocolatey_package('7zip')
    #
    # @example Assert that a specific +chocolatey_package+ version was removed
    #   expect(chef_run).to remove_chocolatey_package('7zip').with(
    #     version: %w(15.14)
    #   )
    #
    # @example Assert that a +chocolatey_package+ was _not_ removed
    #   expect(chef_run).to_not remove_chocolatey_package('7zip')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_chocolatey_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chocolatey_package, :remove, resource_name)
    end

    #
    # Assert that a +chocolatey_package+ resource exists in the Chef run with the
    # action +:upgrade+. Given a Chef Recipe that upgrades "7zip" as a
    # +chocolatey_package+:
    #
    #     chocolatey_package '7zip' do
    #       action :upgrade
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +chocolatey_package+ resource with ChefSpec.
    #
    # @example Assert that a +chocolatey_package+ was upgraded
    #   expect(chef_run).to upgrade_chocolatey_package('7zip')
    #
    # @example Assert that a +chocolatey_package+ was upgraded with attributes
    #   expect(chef_run).to upgrade_chocolatey_package('git').with(
    #     version: %w(2.7.1),
    #     options: '-params "/GitAndUnixToolsOnPath"'
    #  )
    #
    # @example Assert that a +chocolatey_package+ was _not_ upgraded
    #   expect(chef_run).to_not upgrade_chocolatey_package('flashplayeractivex')
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def upgrade_chocolatey_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:chocolatey_package, :upgrade, resource_name)
    end
  end
end
