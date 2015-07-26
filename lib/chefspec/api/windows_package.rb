module ChefSpec::API
  # @since 0.5.0
  module WindowsPackageMatchers
    ChefSpec.define_matcher :windows_package

    #
    # Assert that a +windows_package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "7zip" as a
    # +windows_package+:
    #
    #     windows_package '7zip' do
    #       action :install
    #     end
    #
    # To test the content rendered by a +windows_package+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_package+ resource with ChefSpec.
    #
    # @example Assert that a +windows_package+ was installed
    #   expect(chef_run).to install_windows_package('7zip')
    #
    # @example Assert that a +windows_package+ was installed with predicate matchers
    #   expect(chef_run).to install_windows_package('7zip').with_pattern('BI*')
    #
    # @example Assert that a +windows_package+ was installed with attributes
    #   expect(chef_run).to install_windows_package('7zip').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_package+ was installed using a regex
    #   expect(chef_run).to install_windows_package('7zip').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_package+ was _not_ installed
    #   expect(chef_run).to_not install_windows_package('7zip')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_windows_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_package, :install, resource_name)
    end

    #
    # Assert that a +windows_package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "7zip" as a
    # +windows_package+:
    #
    #     windows_package '7zip' do
    #       action :remove
    #     end
    #
    # To test the content rendered by a +windows_package+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_package+ resource with ChefSpec.
    #
    # @example Assert that a +windows_package+ was removeped
    #   expect(chef_run).to remove_windows_package('7zip')
    #
    # @example Assert that a +windows_package+ was removeped with predicate matchers
    #   expect(chef_run).to remove_windows_package('7zip').with_pattern('BI*')
    #
    # @example Assert that a +windows_package+ was removeped with attributes
    #   expect(chef_run).to remove_windows_package('7zip').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_package+ was removeped using a regex
    #   expect(chef_run).to remove_windows_package('7zip').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_package+ was _not_ removeped
    #   expect(chef_run).to_not remove_windows_package('7zip')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_windows_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_package, :remove, resource_name)
    end
  end
end
