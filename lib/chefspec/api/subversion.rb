module ChefSpec::API
  # @since 3.0.0
  module SubversionMatchers
    ChefSpec.define_matcher :subversion

    #
    # Assert that a +subversion+ resource exists in the Chef run with the
    # action +:checkout+. Given a Chef Recipe that checks out "svn://..." as a
    # +subversion+:
    #
    #     subversion 'svn://...' do
    #       action :checkout
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +subversion+ resource with ChefSpec.
    #
    # @example Assert that a +subversion+ was checked out
    #   expect(chef_run).to checkout_subversion('svn://...')
    #
    # @example Assert that a +subversion+ was checked out with predicate matchers
    #   expect(chef_run).to checkout_subversion('svn://...').with_user('svargo')
    #
    # @example Assert that a +subversion+ was checked out with attributes
    #   expect(chef_run).to checkout_subversion('svn://...').with(user: 'svargo')
    #
    # @example Assert that a +subversion+ was checked out using a regex
    #   expect(chef_run).to checkout_subversion('svn://...').with(user: /sva(.+)/)
    #
    # @example Assert that a +subversion+ was _not_ checked out
    #   expect(chef_run).to_not checkout_subversion('svn://...')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def checkout_subversion(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:subversion, :checkout, resource_name)
    end

    #
    # Assert that a +subversion+ resource exists in the Chef run with the
    # action +:export+. Given a Chef Recipe that exports "svn://" as a
    # +subversion+:
    #
    #     subversion 'svn://' do
    #       action :export
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +subversion+ resource with ChefSpec.
    #
    # @example Assert that a +subversion+ was exported
    #   expect(chef_run).to export_subversion('svn://')
    #
    # @example Assert that a +subversion+ was exported with predicate matchers
    #   expect(chef_run).to export_subversion('svn://').with_user('svargo')
    #
    # @example Assert that a +subversion+ was exported with attributes
    #   expect(chef_run).to export_subversion('svn://').with(user: 'svargo')
    #
    # @example Assert that a +subversion+ was exported using a regex
    #   expect(chef_run).to export_subversion('svn://').with(user: /sva(.+)/)
    #
    # @example Assert that a +subversion+ was _not_ exported
    #   expect(chef_run).to_not export_subversion('svn://')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def export_subversion(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:subversion, :export, resource_name)
    end

    #
    # Assert that a +subversion+ resource exists in the Chef run with the
    # action +:force_export+. Given a Chef Recipe that force_exports "svn://" as a
    # +subversion+:
    #
    #     subversion 'svn://' do
    #       action :force_export
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +subversion+ resource with ChefSpec.
    #
    # @example Assert that a +subversion+ was force_exported
    #   expect(chef_run).to force_export_subversion('svn://')
    #
    # @example Assert that a +subversion+ was force_exported with predicate matchers
    #   expect(chef_run).to force_export_subversion('svn://').with_user('svargo')
    #
    # @example Assert that a +subversion+ was force_exported with attributes
    #   expect(chef_run).to force_export_subversion('svn://').with(user: 'svargo')
    #
    # @example Assert that a +subversion+ was force_exported using a regex
    #   expect(chef_run).to force_export_subversion('svn://').with(user: /sva(.+)/)
    #
    # @example Assert that a +subversion+ was _not_ force_exported
    #   expect(chef_run).to_not force_export_subversion('svn://')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def force_export_subversion(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:subversion, :force_export, resource_name)
    end

    #
    # Assert that a +subversion+ resource exists in the Chef run with the
    # action +:sync+. Given a Chef Recipe that syncs "svn://" as a
    # +subversion+:
    #
    #     subversion 'svn://' do
    #       action :sync
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +subversion+ resource with ChefSpec.
    #
    # @example Assert that a +subversion+ was synced
    #   expect(chef_run).to sync_subversion('svn://')
    #
    # @example Assert that a +subversion+ was synced with predicate matchers
    #   expect(chef_run).to sync_subversion('svn://').with_user('svargo')
    #
    # @example Assert that a +subversion+ was synced with attributes
    #   expect(chef_run).to sync_subversion('svn://').with(user: 'svargo')
    #
    # @example Assert that a +subversion+ was synced using a regex
    #   expect(chef_run).to sync_subversion('svn://').with(user: /sva(.+)/)
    #
    # @example Assert that a +subversion+ was _not_ synced
    #   expect(chef_run).to_not sync_subversion('svn://')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def sync_subversion(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:subversion, :sync, resource_name)
    end
  end
end
