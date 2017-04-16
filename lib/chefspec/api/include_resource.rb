module ChefSpec::API
  # @since 0.2.1
  module IncludeResourceMatchers
    #
    # Assert that a Chef run includes any instance of a resource. Given a Chef Recipe
    # that calls +my_resource+:
    #
    #     my_resource 'a resource'
    #
    # The Examples section demonstrates the different ways to test an
    # +include_resource+ directive with ChefSpec.
    #
    # @example Assert the +my_resource+ resource is included in the Chef run
    #   expect(chef_run).to include_resource('my_resource')
    #
    #
    # @param [String] resource_name
    #   the name of the resource to be included
    #
    # @return [ChefSpec::Matchers::IncludeResourceMatcher]
    #
    def include_resource(recipe_name)
      ChefSpec::Matchers::IncludeResourceMatcher.new(recipe_name)
    end
  end
end
