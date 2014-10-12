module ChefSpec::API
  # @since 0.9.0
  module EnvMatchers
    ChefSpec.define_matcher :env

    #
    # Assert that an +env+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "HOME" as an
    # +env+:
    #
    #     env 'HOME' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +env+ resource with ChefSpec.
    #
    # @example Assert that an +env+ was created
    #   expect(chef_run).to create_env('HOME')
    #
    # @example Assert that an +env+ was created with predicate matchers
    #   expect(chef_run).to create_env('HOME').with_value('/home')
    #
    # @example Assert that an +env+ was created with attributes
    #   expect(chef_run).to create_env('HOME').with(value: 'home')
    #
    # @example Assert that an +env+ was created using a regex
    #   expect(chef_run).to create_env('HOME').with(value: /\/ho(.+)/)
    #
    # @example Assert that an +env+ was _not_ created
    #   expect(chef_run).to_not create_env('HOME')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_env(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:env, :create, resource_name)
    end

    #
    # Assert that an +env+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "HOME" as an
    # +env+:
    #
    #     env 'HOME' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +env+ resource with ChefSpec.
    #
    # @example Assert that an +env+ was deleted
    #   expect(chef_run).to delete_env('HOME')
    #
    # @example Assert that an +env+ was deleted with predicate matchers
    #   expect(chef_run).to delete_env('HOME').with_value('/home')
    #
    # @example Assert that an +env+ was deleted with attributes
    #   expect(chef_run).to delete_env('HOME').with(value: 'home')
    #
    # @example Assert that an +env+ was deleted using a regex
    #   expect(chef_run).to delete_env('HOME').with(value: /\/ho(.+)/)
    #
    # @example Assert that an +env+ was _not_ deleted
    #   expect(chef_run).to_not delete_env('HOME')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_env(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:env, :delete, resource_name)
    end

    #
    # Assert that an +env+ resource exists in the Chef run with the
    # action +:modify+. Given a Chef Recipe that modifies "HOME" as an
    # +env+:
    #
    #     env 'HOME' do
    #       action :modify
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +env+ resource with ChefSpec.
    #
    # @example Assert that an +env+ was modified
    #   expect(chef_run).to modify_env('HOME')
    #
    # @example Assert that an +env+ was modified with predicate matchers
    #   expect(chef_run).to modify_env('HOME').with_value('/home')
    #
    # @example Assert that an +env+ was modified with attributes
    #   expect(chef_run).to modify_env('HOME').with(value: 'home')
    #
    # @example Assert that an +env+ was modified using a regex
    #   expect(chef_run).to modify_env('HOME').with(value: /\/ho(.+)/)
    #
    # @example Assert that an +env+ was _not_ modified
    #   expect(chef_run).to_not modify_env('HOME')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def modify_env(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:env, :modify, resource_name)
    end
  end
end
