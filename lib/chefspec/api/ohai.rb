module ChefSpec::API
  # @since 3.0.0
  module OhaiMatchers
    ChefSpec.define_matcher :ohai

    #
    # Assert that an +ohai+ resource exists in the Chef run with the
    # action +:reload+. Given a Chef Recipe that reloads "reload" as an
    # +ohai+:
    #
    #     ohai 'reload' do
    #       action :reload
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +ohai+ resource with ChefSpec.
    #
    # @example Assert that an +ohai+ was reloaded
    #   expect(chef_run).to reload_ohai('reload')
    #
    # @example Assert that an +ohai+ was reloaded with predicate matchers
    #   expect(chef_run).to reload_ohai('reload').with_system(true)
    #
    # @example Assert that an +ohai+ was reloaded with attributes
    #   expect(chef_run).to reload_ohai('reload').with(system: true)
    #
    # @example Assert that an +ohai+ was reloaded using a regex
    #   expect(chef_run).to reload_ohai('reload').with(system: /true/)
    #
    # @example Assert that an +ohai+ was _not_ reloaded
    #   expect(chef_run).to_not reload_ohai('reload')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def reload_ohai(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ohai, :reload, resource_name)
    end
  end
end
