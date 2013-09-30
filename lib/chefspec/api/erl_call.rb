module ChefSpec::API
  # @since 3.0.0
  module ErlCallMatchers
    ChefSpec::Runner.define_runner_method :erl_call

    #
    # Assert that an +erl_call+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "net_adm:names()" as an
    # +erl_call+:
    #
    #     erl_call 'net_adm:names()' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +erl_call+ resource with ChefSpec.
    #
    # @example Assert that an +erl_call+ was runed
    #   expect(chef_run).to run_erl_call('net_adm:names()')
    #
    # @example Assert that an +erl_call+ was runed with predicate matchers
    #   expect(chef_run).to run_erl_call('net_adm:names()').with_node_name('example')
    #
    # @example Assert that an +erl_call+ was runed with attributes
    #   expect(chef_run).to run_erl_call('net_adm:names()').with(node_name: 'example')
    #
    # @example Assert that an +erl_call+ was runed using a regex
    #   expect(chef_run).to run_erl_call('net_adm:names()').with(node_name: /[a-z]+/)
    #
    # @example Assert that an +erl_call+ was _not_ runed
    #   expect(chef_run).to_not run_erl_call('net_adm:names()')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_erl_call(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:erl_call, :run, resource_name)
    end
  end
end
