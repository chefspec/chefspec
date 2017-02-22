module ChefSpec::API
  # @since 6.0.0
  module CabPackageMatchers
    ChefSpec.define_matcher :cab_package

    #
    # Assert that a +cab_package+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "apache2" as a
    # +cab_package+:
    #
    #     cab_package 'apache2' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +cab_package+ resource with ChefSpec.
    #
    # @example Assert that a +cab_package+ was installed
    #   expect(chef_run).to install_cab_package('apache2')
    #
    # @example Assert that a +cab_package+ was installed with predicate matchers
    #   expect(chef_run).to install_cab_package('apache2').with_version('1.2.3')
    #
    # @example Assert that a +cab_package+ was installed with attributes
    #   expect(chef_run).to install_cab_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that a +cab_package+ was installed using a regex
    #   expect(chef_run).to install_cab_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +cab_package+ was _not_ installed
    #   expect(chef_run).to_not install_cab_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_cab_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:cab_package, :install, resource_name)
    end

    #
    # Assert that a +cab_package+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "apache2" as a
    # +cab_package+:
    #
    #     cab_package 'apache2' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +cab_package+ resource with ChefSpec.
    #
    # @example Assert that a +cab_package+ was removed
    #   expect(chef_run).to remove_cab_package('apache2')
    #
    # @example Assert that a +cab_package+ was removed with predicate matchers
    #   expect(chef_run).to remove_cab_package('apache2').with_version('1.2.3')
    #
    # @example Assert that a +cab_package+ was removed with attributes
    #   expect(chef_run).to remove_cab_package('apache2').with(version: '1.2.3')
    #
    # @example Assert that a +cab_package+ was removed using a regex
    #   expect(chef_run).to remove_cab_package('apache2').with(version: /(\d+\.){2}\.\d+/)
    #
    # @example Assert that a +cab_package+ was _not_ removed
    #   expect(chef_run).to_not remove_cab_package('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_cab_package(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:cab_package, :remove, resource_name)
    end
  end
end
