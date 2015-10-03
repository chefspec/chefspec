module ChefSpec::API
  # @since 1.0.0
  module GroupMatchers
    ChefSpec.define_matcher :group

    #
    # Assert that a +group+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "apache2" as a
    # +group+:
    #
    #     group 'apache2' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +group+ resource with ChefSpec.
    #
    # @example Assert that a +group+ was created
    #   expect(chef_run).to create_group('apache2')
    #
    # @example Assert that a +group+ was created with predicate matchers
    #   expect(chef_run).to create_group('apache2').with_gid(1234)
    #
    # @example Assert that a +group+ was created with attributes
    #   expect(chef_run).to create_group('apache2').with(gid: 1234)
    #
    # @example Assert that a +group+ was created using a regex
    #   expect(chef_run).to create_group('apache2').with(gid: /\d+/)
    #
    # @example Assert that a +group+ was _not_ created
    #   expect(chef_run).to_not create_group('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_group(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:group, :create, resource_name)
    end

    #
    # Assert that a +group+ resource exists in the Chef run with the
    # action +:manage+. Given a Chef Recipe that manages "apache2" as a
    # +group+:
    #
    #     group 'apache2' do
    #       action :manage
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +group+ resource with ChefSpec.
    #
    # @example Assert that a +group+ was managed
    #   expect(chef_run).to manage_group('apache2')
    #
    # @example Assert that a +group+ was managed with predicate matchers
    #   expect(chef_run).to manage_group('apache2').with_gid(1234)
    #
    # @example Assert that a +group+ was managed with attributes
    #   expect(chef_run).to manage_group('apache2').with(gid: 1234)
    #
    # @example Assert that a +group+ was managed using a regex
    #   expect(chef_run).to manage_group('apache2').with(gid: /\d+/)
    #
    # @example Assert that a +group+ was _not_ managed
    #   expect(chef_run).to_not manage_group('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def manage_group(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:group, :manage, resource_name)
    end

    #
    # Assert that a +group+ resource exists in the Chef run with the
    # action +:modify+. Given a Chef Recipe that modifies "apache2" as a
    # +group+:
    #
    #     group 'apache2' do
    #       action :modify
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +group+ resource with ChefSpec.
    #
    # @example Assert that a +group+ was modified
    #   expect(chef_run).to modify_group('apache2')
    #
    # @example Assert that a +group+ was modified with predicate matchers
    #   expect(chef_run).to modify_group('apache2').with_gid(1234)
    #
    # @example Assert that a +group+ was modified with attributes
    #   expect(chef_run).to modify_group('apache2').with(gid: 1234)
    #
    # @example Assert that a +group+ was modified using a regex
    #   expect(chef_run).to modify_group('apache2').with(gid: /\d+/)
    #
    # @example Assert that a +group+ was _not_ modified
    #   expect(chef_run).to_not modify_group('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def modify_group(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:group, :modify, resource_name)
    end

    #
    # Assert that a +group+ resource exists in the Chef run with the
    # action +:remove+. Given a Chef Recipe that removes "apache2" as a
    # +group+:
    #
    #     group 'apache2' do
    #       action :remove
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +group+ resource with ChefSpec.
    #
    # @example Assert that a +group+ was removed
    #   expect(chef_run).to remove_group('apache2')
    #
    # @example Assert that a +group+ was removed with predicate matchers
    #   expect(chef_run).to remove_group('apache2').with_gid(1234)
    #
    # @example Assert that a +group+ was removed with attributes
    #   expect(chef_run).to remove_group('apache2').with(gid: 1234)
    #
    # @example Assert that a +group+ was removed using a regex
    #   expect(chef_run).to remove_group('apache2').with(gid: /\d+/)
    #
    # @example Assert that a +group+ was _not_ removed
    #   expect(chef_run).to_not remove_group('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remove_group(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:group, :remove, resource_name)
    end
  end
end
