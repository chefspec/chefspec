module ChefSpec::API
  # @since 3.0.0
  module RemoteDirectoryMatchers
    ChefSpec.define_matcher :remote_directory

    #
    # Assert that a +remote_directory+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "/tmp" as a
    # +remote_directory+:
    #
    #     remote_directory '/tmp' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_directory+ resource with ChefSpec.
    #
    # @example Assert that a +remote_directory+ was created
    #   expect(chef_run).to create_remote_directory('/tmp')
    #
    # @example Assert that a +remote_directory+ was created with predicate matchers
    #   expect(chef_run).to create_remote_directory('/tmp').with_overwrite(true)
    #
    # @example Assert that a +remote_directory+ was created with attributes
    #   expect(chef_run).to create_remote_directory('/tmp').with(overwrite: true)
    #
    # @example Assert that a +remote_directory+ was created using a regex
    #   expect(chef_run).to create_remote_directory('/tmp').with(overwrite: /true/)
    #
    # @example Assert that a +remote_directory+ was _not_ created
    #   expect(chef_run).to_not create_remote_directory('/tmp')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_remote_directory(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_directory, :create, resource_name)
    end

    #
    # Assert that a +remote_directory+ resource exists in the Chef run with the
    # action +:create_if_missing+. Given a Chef Recipe that creates "/tmp/config"
    # if missing as a +remote_directory+:
    #
    #     remote_directory '/tmp/config' do
    #       action :create_if_missing
    #     end
    #
    # To test the content rendered by a +remote_directory+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_directory+ resource with ChefSpec.
    #
    # @example Assert that a +remote_directory+ was created if missing
    #   expect(chef_run).to create_remote_directory_if_missing('/tmp/config')
    #
    # @example Assert that a +remote_directory+ was created if missing with predicate matchers
    #   expect(chef_run).to create_remote_directory_if_missing('/tmp/config').with_overwrite(true)
    #
    # @example Assert that a +remote_directory+ was created if missing with attributes
    #   expect(chef_run).to create_remote_directory_if_missing('/tmp/config').with(overwrite: true)
    #
    # @example Assert that a +remote_directory+ was created if missing using a regex
    #   expect(chef_run).to create_remote_directory_if_missing('/tmp/config').with(overwrite: /true/)
    #
    # @example Assert that a +remote_directory+ was _not_ created if missing
    #   expect(chef_run).to_not create_remote_directory('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_remote_directory_if_missing(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_directory, :create_if_missing, resource_name)
    end

    #
    # Assert that a +remote_directory+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "/tmp" as a
    # +remote_directory+:
    #
    #     remote_directory '/tmp' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_directory+ resource with ChefSpec.
    #
    # @example Assert that a +remote_directory+ was deleted
    #   expect(chef_run).to delete_remote_directory('/tmp')
    #
    # @example Assert that a +remote_directory+ was deleted with predicate matchers
    #   expect(chef_run).to delete_remote_directory('/tmp').with_overwrite(true)
    #
    # @example Assert that a +remote_directory+ was deleted with attributes
    #   expect(chef_run).to delete_remote_directory('/tmp').with(overwrite: true)
    #
    # @example Assert that a +remote_directory+ was deleted using a regex
    #   expect(chef_run).to delete_remote_directory('/tmp').with(overwrite: /true/)
    #
    # @example Assert that a +remote_directory+ was _not_ deleted
    #   expect(chef_run).to_not delete_remote_directory('/tmp')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_remote_directory(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_directory, :delete, resource_name)
    end
  end
end
