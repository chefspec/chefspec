module ChefSpec::API
  # @since 0.0.1
  module FileMatchers
    ChefSpec.define_matcher :file

    #
    # Assert that a +file+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "/tmp/config" as a
    # +file+:
    #
    #     file '/tmp/config' do
    #       action :create
    #     end
    #
    # To test the content rendered by a +file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +file+ resource with ChefSpec.
    #
    # @example Assert that a +file+ was created
    #   expect(chef_run).to create_file('/tmp/config')
    #
    # @example Assert that a +file+ was created with predicate matchers
    #   expect(chef_run).to create_file('/tmp/config').with_backup(false)
    #
    # @example Assert that a +file+ was created with attributes
    #   expect(chef_run).to create_file('/tmp/config').with(backup: false)
    #
    # @example Assert that a +file+ was created using a regex
    #   expect(chef_run).to create_file('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +file+ was _not_ created
    #   expect(chef_run).to_not create_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_file(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:file, :create, resource_name)
    end

    #
    # Assert that a +file+ resource exists in the Chef run with the
    # action +:create_if_missing+. Given a Chef Recipe that creates "/tmp/config"
    # if missing as a +file+:
    #
    #     file '/tmp/config' do
    #       action :create_if_missing
    #     end
    #
    # To test the content rendered by a +file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +file+ resource with ChefSpec.
    #
    # @example Assert that a +file+ was created if missing
    #   expect(chef_run).to create_file_if_missing('/tmp/config')
    #
    # @example Assert that a +file+ was created if missing with predicate matchers
    #   expect(chef_run).to create_file_if_missing('/tmp/config').with_backup(false)
    #
    # @example Assert that a +file+ was created if missing with attributes
    #   expect(chef_run).to create_file_if_missing('/tmp/config').with(backup: false)
    #
    # @example Assert that a +file+ was created if missing using a regex
    #   expect(chef_run).to create_file_if_missing('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +file+ was _not_ created if missing
    #   expect(chef_run).to_not create_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_file_if_missing(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:file, :create_if_missing, resource_name)
    end

    #
    # Assert that a +file+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "/tmp/config" as a
    # +file+:
    #
    #     file '/tmp/config' do
    #       action :delete
    #     end
    #
    # To test the content rendered by a +file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +file+ resource with ChefSpec.
    #
    # @example Assert that a +file+ was deleted
    #   expect(chef_run).to delete_file('/tmp/config')
    #
    # @example Assert that a +file+ was deleted with predicate matchers
    #   expect(chef_run).to delete_file('/tmp/config').with_backup(false)
    #
    # @example Assert that a +file+ was deleted with attributes
    #   expect(chef_run).to delete_file('/tmp/config').with(backup: false)
    #
    # @example Assert that a +file+ was deleted using a regex
    #   expect(chef_run).to delete_file('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +file+ was _not_ deleted
    #   expect(chef_run).to_not delete_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_file(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:file, :delete, resource_name)
    end

    #
    # Assert that a +file+ resource exists in the Chef run with the
    # action +:touch+. Given a Chef Recipe that touches "/tmp/config" as a
    # +file+:
    #
    #     file '/tmp/config' do
    #       action :touch
    #     end
    #
    # To test the content rendered by a +file+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +file+ resource with ChefSpec.
    #
    # @example Assert that a +file+ was touched
    #   expect(chef_run).to touch_file('/tmp/config')
    #
    # @example Assert that a +file+ was touched with predicate matchers
    #   expect(chef_run).to touch_file('/tmp/config').with_backup(false)
    #
    # @example Assert that a +file+ was touched with attributes
    #   expect(chef_run).to touch_file('/tmp/config').with(backup: false)
    #
    # @example Assert that a +file+ was touched using a regex
    #   expect(chef_run).to touch_file('/tmp/config').with(user: /apa(.+)/)
    #
    # @example Assert that a +file+ was _not_ touched
    #   expect(chef_run).to_not touch_file('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def touch_file(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:file, :touch, resource_name)
    end
  end
end
