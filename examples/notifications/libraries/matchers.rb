if defined?(ChefSpec)
  ChefSpec.define_matcher :notifications

  def test(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:notifications, :create, resource_name)
  end
end
