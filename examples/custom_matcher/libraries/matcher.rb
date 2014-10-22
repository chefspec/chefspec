if defined?(ChefSpec)
  ChefSpec.define_matcher :custom_matcher_thing

  #
  # When defining a custom LWRP matcher, you should always add some
  # documentation indicating how to use the custom matcher.
  #
  # @example This is an example
  #   expect(chef_run).to install_custom_matcher_thing('foo')
  #
  # @param [String] resource_name
  #   the resource name
  #
  # @return [ChefSpec::Matchers::ResourceMatcher]
  #
  def install_custom_matcher_thing(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:custom_matcher_thing, :install, resource_name)
  end

  def remove_custom_matcher_thing(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:custom_matcher_thing, :remove, resource_name)
  end
end
