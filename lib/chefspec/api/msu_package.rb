module ChefSpec::API
  # @since 6.0.0
  module MsuPackageMatchers
    ChefSpec.define_matcher :msu_package

    #
    # Assert that a +msu_package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "KB2959977" as a
    # +msu_package+:
    #
    #      msu_package 'KB2959977' do
    #        source 'C:\Windows8.1-KB2959977-x64.msu'
    #        action :install
    #      end
    #
    # The Examples section demonstrates the different ways to test a
    # +msu_package+ resource with ChefSpec.
    #
    # @example Assert that a +msu_package+ was installed
    #   expect(chef_run).to install_msu_package('KB2959977')
    #
    # @example Assert that a +msu_package+ was installed with predicate matchers
    #   expect(chef_run).to install_msu_package('KB2959977').with_source('C:\Windows8.1-KB2959977-x64.msu')
    #
    # @example Assert that a +msu_package+ was installed with attributes
    #   expect(chef_run).to install_msu_package('KB2959977').with(source: 'C:\Windows8.1-KB2959977-x64.msu')
    #
    # @example Assert that a +msu_package+ was installed using a regex
    #   expect(chef_run).to install_msu_package('KB2959977').with(source: /.*KB2959977.*/)
    #
    # @example Assert that a +msu_package+ was _not_ installed
    #   expect(chef_run).to_not install_msu_package('KB2959977')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_msu_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:msu_package, :install, resource_name)
    end

    #
    # Assert that a +msu_package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "KB2959977" as a
    # +msu_package+:
    #
    #     msu_package 'KB2959977' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +msu_package+ resource with ChefSpec.
    #
    # @example Assert that a +msu_package+ was removed
    #   expect(chef_run).to remove_msu_package('KB2959977')
    #
    # @example Assert that a +msu_package+ was removed with predicate matchers
    #   expect(chef_run).to remove_msu_package('KB2959977').with_source('C:\Windows8.1-KB2959977-x64.msu')
    #
    # @example Assert that a +msu_package+ was removed with attributes
    #   expect(chef_run).to remove_msu_package('KB2959977').with(source: 'C:\Windows8.1-KB2959977-x64.msu')
    #
    # @example Assert that a +msu_package+ was removed using a regex
    #   expect(chef_run).to remove_msu_package('KB2959977').with(source: /.*KB2959977.*/)
    #
    # @example Assert that a +msu_package+ was _not_ removed
    #   expect(chef_run).to_not remove_msu_package('KB2959977')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_msu_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:msu_package, :remove, resource_name)
    end
  end
end
