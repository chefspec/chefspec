module ChefSpec::API
  # @since 3.0.0
  module GitMatchers
    ChefSpec.define_matcher :git

    #
    # Assert that a +git+ resource exists in the Chef run with the
    # action +:checkout+. Given a Chef Recipe that checks out "git://..." as a
    # +git+:
    #
    #     git 'git://...' do
    #       action :checkout
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +git+ resource with ChefSpec.
    #
    # @example Assert that a +git+ was checked out
    #   expect(chef_run).to checkout_git('git://...')
    #
    # @example Assert that a +git+ was checked out with predicate matchers
    #   expect(chef_run).to checkout_git('git://...').with_user('svargo')
    #
    # @example Assert that a +git+ was checked out with attributes
    #   expect(chef_run).to checkout_git('git://...').with(user: 'svargo')
    #
    # @example Assert that a +git+ was checked out using a regex
    #   expect(chef_run).to checkout_git('git://...').with(user: /sva(.+)/)
    #
    # @example Assert that a +git+ was _not_ checked out
    #   expect(chef_run).to_not checkout_git('git://...')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def checkout_git(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:git, :checkout, resource_name)
    end

    #
    # Assert that a +git+ resource exists in the Chef run with the
    # action +:export+. Given a Chef Recipe that exports "git://" as a
    # +git+:
    #
    #     git 'git://' do
    #       action :export
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +git+ resource with ChefSpec.
    #
    # @example Assert that a +git+ was exported
    #   expect(chef_run).to export_git('git://')
    #
    # @example Assert that a +git+ was exported with predicate matchers
    #   expect(chef_run).to export_git('git://').with_user('svargo')
    #
    # @example Assert that a +git+ was exported with attributes
    #   expect(chef_run).to export_git('git://').with(user: 'svargo')
    #
    # @example Assert that a +git+ was exported using a regex
    #   expect(chef_run).to export_git('git://').with(user: /sva(.+)/)
    #
    # @example Assert that a +git+ was _not_ exported
    #   expect(chef_run).to_not export_git('git://')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def export_git(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:git, :export, resource_name)
    end

    #
    # Assert that a +git+ resource exists in the Chef run with the
    # action +:sync+. Given a Chef Recipe that syncs "git://" as a
    # +git+:
    #
    #     git 'git://' do
    #       action :sync
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +git+ resource with ChefSpec.
    #
    # @example Assert that a +git+ was synced
    #   expect(chef_run).to sync_git('git://')
    #
    # @example Assert that a +git+ was synced with predicate matchers
    #   expect(chef_run).to sync_git('git://').with_user('svargo')
    #
    # @example Assert that a +git+ was synced with attributes
    #   expect(chef_run).to sync_git('git://').with(user: 'svargo')
    #
    # @example Assert that a +git+ was synced using a regex
    #   expect(chef_run).to sync_git('git://').with(user: /sva(.+)/)
    #
    # @example Assert that a +git+ was _not_ synced
    #   expect(chef_run).to_not sync_git('git://')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def sync_git(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:git, :sync, resource_name)
    end
  end
end
