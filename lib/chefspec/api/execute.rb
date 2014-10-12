module ChefSpec::API
  # @since 0.0.1
  module ExecuteMatchers
    ChefSpec.define_matcher :execute

    #
    # Assert that an +execute+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "echo "hello"" as an
    # +execute+:
    #
    #     execute 'echo "hello"' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +execute+ resource with ChefSpec.
    #
    # @example Assert that an +execute+ was run
    #   expect(chef_run).to run_execute('echo "hello"')
    #
    # @example Assert that an +execute+ was run with predicate matchers
    #   expect(chef_run).to run_execute('echo "hello"').with_user('svargo')
    #
    # @example Assert that an +execute+ was run with attributes
    #   expect(chef_run).to run_execute('echo "hello"').with(user: 'svargo')
    #
    # @example Assert that an +execute+ was run using a regex
    #   expect(chef_run).to run_execute('echo "hello"').with(user: /sva(.+)/)
    #
    # @example Assert that an +execute+ was _not_ run
    #   expect(chef_run).to_not run_execute('echo "hello"')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_execute(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:execute, :run, resource_name)
    end
  end
end
