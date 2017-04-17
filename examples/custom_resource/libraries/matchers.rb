if defined?(ChefSpec)
  def run_custom_resource(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:custom_resource, :run, resource_name)
  end
end
