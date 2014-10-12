module ChefSpec::API
  # @since 1.0.0
  module RemoteFileMatchers
    ChefSpec.define_matcher :remote_file

    #
    # Assert that a +remote_file+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "/tmp/config" as a
    # +remote_file+:
    #
    #     remote_file '/tmp/config' do
    #       action :create
    #     end
    #
    # To test the content rendered by a +remote_file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_file+ resource with ChefSpec.
    #
    # @example Assert that a +remote_file+ was created
    #   expect(chef_run).to create_remote_file('/tmp/config')
    #
    # @example Assert that a +remote_file+ was created with predicate matchers
    #   expect(chef_run).to create_remote_file('/tmp/config').with_backup(false)
    #
    # @example Assert that a +remote_file+ was created with attributes
    #   expect(chef_run).to create_remote_file('/tmp/config').with(backup: false)
    #
    # @example Assert that a +remote_file+ was created using a regex
    #   expect(chef_run).to create_remote_file('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +remote_file+ was _not_ created
    #   expect(chef_run).to_not create_remote_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_remote_file(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_file, :create, resource_name)
    end

    #
    # Assert that a +remote_file+ resource exists in the Chef run with the
    # action +:create_if_missing+. Given a Chef Recipe that creates "/tmp/config"
    # if missing as a +remote_file+:
    #
    #     remote_file '/tmp/config' do
    #       action :create_if_missing
    #     end
    #
    # To test the content rendered by a +remote_file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_file+ resource with ChefSpec.
    #
    # @example Assert that a +remote_file+ was created if missing
    #   expect(chef_run).to create_remote_file_if_missing('/tmp/config')
    #
    # @example Assert that a +remote_file+ was created if missing with predicate matchers
    #   expect(chef_run).to create_remote_file_if_missing('/tmp/config').with_backup(false)
    #
    # @example Assert that a +remote_file+ was created if missing with attributes
    #   expect(chef_run).to create_remote_file_if_missing('/tmp/config').with(backup: false)
    #
    # @example Assert that a +remote_file+ was created if missing using a regex
    #   expect(chef_run).to create_remote_file_if_missing('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +remote_file+ was _not_ created if missing
    #   expect(chef_run).to_not create_remote_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_remote_file_if_missing(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_file, :create_if_missing, resource_name)
    end

    #
    # Assert that a +remote_file+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "/tmp/config" as a
    # +remote_file+:
    #
    #     remote_file '/tmp/config' do
    #       action :delete
    #     end
    #
    # To test the content rendered by a +remote_file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_file+ resource with ChefSpec.
    #
    # @example Assert that a +remote_file+ was deleted
    #   expect(chef_run).to delete_remote_file('/tmp/config')
    #
    # @example Assert that a +remote_file+ was deleted with predicate matchers
    #   expect(chef_run).to delete_remote_file('/tmp/config').with_backup(false)
    #
    # @example Assert that a +remote_file+ was deleted with attributes
    #   expect(chef_run).to delete_remote_file('/tmp/config').with(backup: false)
    #
    # @example Assert that a +remote_file+ was deleted using a regex
    #   expect(chef_run).to delete_remote_file('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +remote_file+ was _not_ deleted
    #   expect(chef_run).to_not delete_remote_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_remote_file(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_file, :delete, resource_name)
    end

    #
    # Assert that a +remote_file+ resource exists in the Chef run with the
    # action +:touch+. Given a Chef Recipe that touches "/tmp/config" as a
    # +remote_file+:
    #
    #     remote_file '/tmp/config' do
    #       action :touch
    #     end
    #
    # To test the content rendered by a +remote_file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +remote_file+ resource with ChefSpec.
    #
    # @example Assert that a +remote_file+ was touched
    #   expect(chef_run).to touch_remote_file('/tmp/config')
    #
    # @example Assert that a +remote_file+ was touched with predicate matchers
    #   expect(chef_run).to touch_remote_file('/tmp/config').with_backup(false)
    #
    # @example Assert that a +remote_file+ was touched with attributes
    #   expect(chef_run).to touch_remote_file('/tmp/config').with(backup: false)
    #
    # @example Assert that a +remote_file+ was touched using a regex
    #   expect(chef_run).to touch_remote_file('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +remote_file+ was _not_ touched
    #   expect(chef_run).to_not touch_remote_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def touch_remote_file(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:remote_file, :touch, resource_name)
    end
  end
end
