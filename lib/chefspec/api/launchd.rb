module ChefSpec::API
  # @since 5.1.0
  module LaunchdMatchers
    ChefSpec.define_matcher :launchd

    #
    # Assert that a +launchd+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates the launchd daemon
    # "com.chef.every15":
    #
    #     launchd 'com.chef.every15' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +launchd+ resource with ChefSpec.
    #
    # @example Assert that a +launchd+ was created
    #   expect(chef_run).to create_launchd('com.chef.every15')
    #
    # @example Assert that a +launchd+ was _not_ created
    #   expect(chef_run).to_not create_launchd('com.chef.every15')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def create_launchd(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:launchd, :create, resource_name)
    end

    #
    # Assert that a +launchd+ resource exists in the Chef run with the
    # action +:create_if_missing+. Given a Chef Recipe that creates if missing
    # the launchd daemon "com.chef.every15":
    #
    #     launchd 'com.chef.every15' do
    #       action :create_if_missing
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +launchd+ resource with ChefSpec.
    #
    # @example Assert that a +launchd+ was created
    #   expect(chef_run).to create_if_missing_launchd('com.chef.every15')
    #
    # @example Assert that a +launchd+ was _not_ created
    #   expect(chef_run).to_not create_if_missing_launchd('com.chef.every15')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def create_if_missing_launchd(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:launchd, :create_if_missing, resource_name)
    end

    #
    # Assert that a +launchd+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes the launchd daemon
    # "com.chef.every15":
    #
    #     launchd 'com.chef.every15' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +launchd+ resource with ChefSpec.
    #
    # @example Assert that a +launchd+ was deleted
    #   expect(chef_run).to delete_launchd('com.chef.every15')
    #
    # @example Assert that a +launchd+ was _not_ deleted
    #   expect(chef_run).to_not delete_launchd('com.chef.every15')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def delete_launchd(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:launchd, :delete, resource_name)
    end

    #
    # Assert that a +launchd+ resource exists in the Chef run with the
    # action +:disable+. Given a Chef Recipe that disables the launchd daemon
    # "com.chef.every15":
    #
    #     launchd 'com.chef.every15' do
    #       action :disable
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +launchd+ resource with ChefSpec.
    #
    # @example Assert that a +launchd+ was disabled
    #   expect(chef_run).to disable_launchd('com.chef.every15')
    #
    # @example Assert that a +launchd+ was _not_ disabled
    #   expect(chef_run).to_not disable_launchd('com.chef.every15')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def disable_launchd(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:launchd, :disable, resource_name)
    end

    #
    # Assert that a +launchd+ resource exists in the Chef run with the
    # action +:enable+. Given a Chef Recipe that enables the launchd daemon
    # "com.chef.every15":
    #
    #     launchd 'com.chef.every15' do
    #       action :enables
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +launchd+ resource with ChefSpec.
    #
    # @example Assert that a +launchd+ was enabled
    #   expect(chef_run).to enable_launchd('com.chef.every15')
    #
    # @example Assert that a +launchd+ was _not_ enabled
    #   expect(chef_run).to_not enable_launchd('com.chef.every15')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def enable_launchd(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:launchd, :enable, resource_name)
    end
  end
end
