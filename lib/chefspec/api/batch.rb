module ChefSpec::API
  # @since 3.0.0
  module BatchMatchers
    ChefSpec.define_matcher :batch

    #
    # Assert that a +batch+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "unzip" using
    # +batch+:
    #
    #     batch 'unzip' do
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +batch+ resource with ChefSpec.
    #
    # @example Assert that a +batch+ was run
    #   expect(chef_run).to run_batch('unzip')
    #
    # @example Assert that a +batch+ was run with predicate matchers
    #   expect(chef_run).to run_batch('unzip').with_cwd('/home')
    #
    # @example Assert that a +batch+ was run with attributes
    #   expect(chef_run).to run_batch('unzip').with(cwd: '/home')
    #
    # @example Assert that a +batch+ was run using a regex
    #   expect(chef_run).to run_batch('unzip').with(cwd: /\/(.+)/)
    #
    # @example Assert that a +batch+ was _not_ run
    #   expect(chef_run).to_not run_batch('unzip')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_batch(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:batch, :run, resource_name)
    end
  end
end
