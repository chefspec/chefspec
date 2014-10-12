module ChefSpec::API
  # @since 3.0.0
  module DeployMatchers
    ChefSpec.define_matcher :deploy

    #
    # Assert that a +deploy+ resource exists in the Chef run with the
    # action +:deploy+. Given a Chef Recipe that deploys "/tmp/path" as a
    # +deploy+:
    #
    #     deploy '/tmp/path' do
    #       action :deploy
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +deploy+ resource with ChefSpec.
    #
    # @example Assert that a +deploy+ was deployed
    #   expect(chef_run).to deploy_deploy('/tmp/path')
    #
    # @example Assert that a +deploy+ was deployed with predicate matchers
    #   expect(chef_run).to deploy_deploy('/tmp/path').with_repo('ssh://...')
    #
    # @example Assert that a +deploy+ was deployed with attributes
    #   expect(chef_run).to deploy_deploy('/tmp/path').with(repo: 'ssh://...')
    #
    # @example Assert that a +deploy+ was deployed using a regex
    #   expect(chef_run).to deploy_deploy('/tmp/path').with(repo: /ssh:(.+)/)
    #
    # @example Assert that a +deploy+ was _not_ deployed
    #   expect(chef_run).to_not deploy_deploy('/tmp/path')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def deploy_deploy(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:deploy, :deploy, resource_name)
    end

    #
    # Assert that a +deploy+ resource exists in the Chef run with the
    # action +:force_deploy+. Given a Chef Recipe that force_deploys "/tmp/path" as a
    # +deploy+:
    #
    #     deploy '/tmp/path' do
    #       action :force_deploy
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +deploy+ resource with ChefSpec.
    #
    # @example Assert that a +deploy+ was force_deployed
    #   expect(chef_run).to force_deploy_deploy('/tmp/path')
    #
    # @example Assert that a +deploy+ was force_deployed with predicate matchers
    #   expect(chef_run).to force_deploy_deploy('/tmp/path').with_repo('ssh://...')
    #
    # @example Assert that a +deploy+ was force_deployed with attributes
    #   expect(chef_run).to force_deploy_deploy('/tmp/path').with(repo: 'ssh://...')
    #
    # @example Assert that a +deploy+ was force_deployed using a regex
    #   expect(chef_run).to force_deploy_deploy('/tmp/path').with(repo: /ssh:(.+)/)
    #
    # @example Assert that a +deploy+ was _not_ force_deployed
    #   expect(chef_run).to_not force_deploy_deploy('/tmp/path')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def force_deploy_deploy(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:deploy, :force_deploy, resource_name)
    end

    #
    # Assert that a +deploy+ resource exists in the Chef run with the
    # action +:rollback+. Given a Chef Recipe that rolls back "/tmp/path" as a
    # +deploy+:
    #
    #     deploy '/tmp/path' do
    #       action :rollback
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +deploy+ resource with ChefSpec.
    #
    # @example Assert that a +deploy+ was rolled back
    #   expect(chef_run).to rollback_deploy('/tmp/path')
    #
    # @example Assert that a +deploy+ was rolled back with predicate matchers
    #   expect(chef_run).to rollback_deploy('/tmp/path').with_repo('ssh://...')
    #
    # @example Assert that a +deploy+ was rolled back with attributes
    #   expect(chef_run).to rollback_deploy('/tmp/path').with(repo: 'ssh://...')
    #
    # @example Assert that a +deploy+ was rolled back using a regex
    #   expect(chef_run).to rollback_deploy('/tmp/path').with(repo: /ssh:(.+)/)
    #
    # @example Assert that a +deploy+ was _not_ rolled back
    #   expect(chef_run).to_not rollback_deploy('/tmp/path')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def rollback_deploy(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:deploy, :rollback, resource_name)
    end
  end
end
