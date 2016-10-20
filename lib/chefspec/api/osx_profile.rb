module ChefSpec::API
  # @since 5.1.0
  module OsxProfileMatchers
    ChefSpec.define_matcher :osx_profile

    #
    # Assert that an +osx_profile+ resource exists in the Chef run with the
    # action +:install+. Given a Chef Recipe that installs "bsmith" as an
    # +profile+:
    #
    #     osx_profile 'bsmith' do
    #       action :install
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +osx_profile+ resource with ChefSpec.
    #
    # @example Assert that an +osx_profile+ was installed
    #   expect(chef_run).to install_osx_profile('bsmith')
    #
    # @example Assert that an +osx_profile+ was _not_ installed
    #   expect(chef_run).to_not install_osx_profile('bsmith')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def install_osx_profile(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:osx_profile, :install, resource_name)
    end

    #
    # Assert that an +osx_profile+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "bsmith" as an
    # +profile+:
    #
    #     osx_profile 'bsmith' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +osx_profile+ resource with ChefSpec.
    #
    # @example Assert that an +osx_profile+ was removed
    #   expect(chef_run).to remove_osx_profile('bsmith')
    #
    # @example Assert that an +osx_profile+ was _not_ removed
    #   expect(chef_run).to_not remove_osx_profile('bsmith')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_osx_profile(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:osx_profile, :remove, resource_name)
    end

  end
end
