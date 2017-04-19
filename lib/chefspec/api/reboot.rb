module ChefSpec::API
  def now_reboot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:reboot, :reboot_now, resource_name)
  end

  def request_reboot(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:reboot, :request_reboot, resource_name)
  end
end
