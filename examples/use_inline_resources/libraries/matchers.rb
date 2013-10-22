if defined?(ChefSpec)
  def run_use_inline_resources_lwrp(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:use_inline_resources_lwrp, :run, resource_name)
  end
end
