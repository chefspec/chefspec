module ChefSpec::API
  # @since 3.0.0
  module LogMatchers
    ChefSpec.define_matcher :log

    #
    # Assert that a +log+ resource exists in the Chef run with the
    # action +:write+. Given a Chef Recipe that writes "message" as a
    # +log+:
    #
    #     log 'message' do
    #       action :write
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +log+ resource with ChefSpec.
    #
    # @example Assert that a +log+ was writeed
    #   expect(chef_run).to write_log('message')
    #
    # @example Assert that a +log+ was writeed with predicate matchers
    #   expect(chef_run).to write_log('message').with_level(:info)
    #
    # @example Assert that a +log+ was writeed with attributes
    #   expect(chef_run).to write_log('message').with(level: :info)
    #
    # @example Assert that a +log+ was writeed using a regex
    #   expect(chef_run).to write_log('message').with(level: Symbol)
    #
    # @example Assert that a +log+ was _not_ writeed
    #   expect(chef_run).to_not write_log('message')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def write_log(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:log, :write, resource_name)
    end
  end
end
