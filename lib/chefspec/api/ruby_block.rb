module ChefSpec::API
  # @since 0.5.0
  module RubyBlockMatchers
    ChefSpec.define_matcher :ruby_block

    #
    # Assert that a +ruby_block+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that runs "do_something" as a
    # +ruby_block+:
    #
    #     ruby_block 'do_something' do
    #       block do
    #         # ...
    #       end
    #       action :run
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +ruby_block+ resource with ChefSpec.
    #
    # @example Assert that a +ruby_block+ was run
    #   expect(chef_run).to run_ruby_block('do_something')
    #
    # @example Assert that a +ruby_block+ was _not_ run
    #   expect(chef_run).to_not run_ruby_block('do_something')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_ruby_block(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ruby_block, :run, resource_name)
    end

    #
    # Assert that a +ruby_block+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that runs "do_something" as a
    # +ruby_block+:
    #
    #     ruby_block 'do_something' do
    #       block do
    #         # ...
    #       end
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +ruby_block+ resource with ChefSpec.
    #
    # @example Assert that a +ruby_block+ was run
    #   expect(chef_run).to create_ruby_block('do_something')
    #
    # @example Assert that a +ruby_block+ was _not_ run
    #   expect(chef_run).to_not create_ruby_block('do_something')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_ruby_block(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ruby_block, :create, resource_name)
    end
  end
end
