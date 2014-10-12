module ChefSpec::API
  # @since 1.1.0
  module LinkMatchers
    ChefSpec.define_matcher :link

    #
    # Assert that a +link+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "/tmp" as a
    # +link+:
    #
    #     link '/tmp' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +link+ resource with ChefSpec.
    #
    # @example Assert that a +link+ was createed
    #   expect(chef_run).to create_link('/tmp')
    #
    # @example Assert that a +link+ was createed with predicate matchers
    #   expect(chef_run).to create_link('/tmp').with_link_type(:hard)
    #
    # @example Assert that a +link+ was createed with attributes
    #   expect(chef_run).to create_link('/tmp').with(link_type: :hard)
    #
    # @example Assert that a +link+ was createed using a regex
    #   expect(chef_run).to create_link('/tmp').with(link_type: Symbol)
    #
    # @example Assert that a +link+ was _not_ createed
    #   expect(chef_run).to_not create_link('/tmp')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_link(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:link, :create, resource_name)
    end

    #
    # Assert that a +link+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "/tmp" as a
    # +link+:
    #
    #     link '/tmp' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +link+ resource with ChefSpec.
    #
    # @example Assert that a +link+ was deleteed
    #   expect(chef_run).to delete_link('/tmp')
    #
    # @example Assert that a +link+ was deleteed with predicate matchers
    #   expect(chef_run).to delete_link('/tmp').with_link_type(:hard)
    #
    # @example Assert that a +link+ was deleteed with attributes
    #   expect(chef_run).to delete_link('/tmp').with(link_type: :hard)
    #
    # @example Assert that a +link+ was deleteed using a regex
    #   expect(chef_run).to delete_link('/tmp').with(link_type: Symbol)
    #
    # @example Assert that a +link+ was _not_ deleteed
    #   expect(chef_run).to_not delete_link('/tmp')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_link(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:link, :delete, resource_name)
    end

    #
    # Assert that a symlink links to a specific path. This is really
    # syntactic sugar for the following:
    #
    #       expect(chef_run).to create_link('/tmp/thing').with(to: '/tmp/other_thing')
    #
    # @example Using +link_to+ with a String path
    #   link = chef_run.link('/tmp/thing')
    #   expect(link).to link_to('/tmp/other_thing')
    #
    # @example Using +link_to+ with a regular expression
    #   expect(link).to link_to(/\/tmp/(.+)/)
    #
    # @param [String, Regex] path
    #   the path to link to
    #
    # @return [ChefSpec::Matchers::LinkToMatcher]
    #
    def link_to(path)
      ChefSpec::Matchers::LinkToMatcher.new(path)
    end
  end
end
