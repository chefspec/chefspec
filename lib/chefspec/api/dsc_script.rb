module ChefSpec::API
  # @since 5.1.0
  module DscScriptMatchers
    ChefSpec.define_matcher :dsc_script

    #
    # Assert that a +dsc_script+ resource exists in the Chef run with
    # the action +:run+. Given a Chef Recipe that runs "something" using
    # +dsc_script+:
    #
    #     dsc_script 'something' do
    #       code <<-EOH
    #         something
    #       EOH
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +dsc_script+ resource with ChefSpec.
    #
    # @example Assert that a +dsc_script+ was run
    #   expect(chef_run).to dsc_script('something')
    #
    # @example Assert that a +dsc_script+ was _not_ run
    #   expect(chef_run).to_not dsc_script('something')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_dsc_script(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:dsc_script, :run, resource_name)
    end
  end
end
