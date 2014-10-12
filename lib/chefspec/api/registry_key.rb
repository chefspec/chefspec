module ChefSpec::API
  # @since 3.0.0
  module RegistryKeyMatchers
    ChefSpec.define_matcher :registry_key

    #
    # Assert that a +registry_key+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "HKEY_LOCAL_MACHINE\\SOFTWARE" as a
    # +registry_key+:
    #
    #     registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE' do
    #       action :create
    #     end
    #
    # To test the content rendered by a +registry_key+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +registry_key+ resource with ChefSpec.
    #
    # @example Assert that a +registry_key+ was created
    #   expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    # @example Assert that a +registry_key+ was created with predicate matchers
    #   expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with_recursive(false)
    #
    # @example Assert that a +registry_key+ was created with attributes
    #   expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with(recursive: false)
    #
    # @example Assert that a +registry_key+ was created using a regex
    #   expect(chef_run).to create_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with(values: Array)
    #
    # @example Assert that a +registry_key+ was _not_ created
    #   expect(chef_run).to_not create_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_registry_key(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:registry_key, :create, resource_name)
    end

    #
    # Assert that a +registry_key+ resource exists in the Chef run with the
    # action +:create_if_missing+. Given a Chef Recipe that creates "HKEY_LOCAL_MACHINE\\SOFTWARE"
    # if missing as a +registry_key+:
    #
    #     registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE' do
    #       action :create_if_missing
    #     end
    #
    # To test the content rendered by a +registry_key+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +registry_key+ resource with ChefSpec.
    #
    # @example Assert that a +registry_key+ was created if missing
    #   expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    # @example Assert that a +registry_key+ was created if missing with predicate matchers
    #   expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\\SOFTWARE').with_recursive(false)
    #
    # @example Assert that a +registry_key+ was created if missing with attributes
    #   expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\\SOFTWARE').with(recursive: false)
    #
    # @example Assert that a +registry_key+ was created if missing using a regex
    #   expect(chef_run).to create_registry_key_if_missing('HKEY_LOCAL_MACHINE\\SOFTWARE').with(values: Array)
    #
    # @example Assert that a +registry_key+ was _not_ created if missing
    #   expect(chef_run).to_not create_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_registry_key_if_missing(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:registry_key, :create_if_missing, resource_name)
    end

    #
    # Assert that a +registry_key+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "HKEY_LOCAL_MACHINE\\SOFTWARE" as a
    # +registry_key+:
    #
    #     registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE' do
    #       action :delete
    #     end
    #
    # To test the content rendered by a +registry_key+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +registry_key+ resource with ChefSpec.
    #
    # @example Assert that a +registry_key+ was deleted
    #   expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    # @example Assert that a +registry_key+ was deleted with predicate matchers
    #   expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with_recursive(false)
    #
    # @example Assert that a +registry_key+ was deleted with attributes
    #   expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with(recursive: false)
    #
    # @example Assert that a +registry_key+ was deleted using a regex
    #   expect(chef_run).to delete_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with(values: Array)
    #
    # @example Assert that a +registry_key+ was _not_ deleted
    #   expect(chef_run).to_not delete_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_registry_key(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:registry_key, :delete, resource_name)
    end

    #
    # Assert that a +registry_key+ resource exists in the Chef run with the
    # action +:delete_key+. Given a Chef Recipe that delete_keys "HKEY_LOCAL_MACHINE\\SOFTWARE" as a
    # +registry_key+:
    #
    #     registry_key 'HKEY_LOCAL_MACHINE\\SOFTWARE' do
    #       action :delete_key
    #     end
    #
    # To test the content rendered by a +registry_key+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +registry_key+ resource with ChefSpec.
    #
    # @example Assert that a +registry_key+ was delete_keyd
    #   expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    # @example Assert that a +registry_key+ was delete_keyd with predicate matchers
    #   expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with_recursive(false)
    #
    # @example Assert that a +registry_key+ was delete_keyd with attributes
    #   expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with(recursive: false)
    #
    # @example Assert that a +registry_key+ was delete_keyd using a regex
    #   expect(chef_run).to delete_key_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE').with(values: Array)
    #
    # @example Assert that a +registry_key+ was _not_ delete_keyd
    #   expect(chef_run).to_not delete_key_registry_key('HKEY_LOCAL_MACHINE\\SOFTWARE')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_key_registry_key(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:registry_key, :delete_key, resource_name)
    end
  end
end
