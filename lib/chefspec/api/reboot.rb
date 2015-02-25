module ChefSpec::API
  # @since 0.5.0
  module RebootMatchers
    ChefSpec.define_matcher :reboot

    def now_reboot(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:reboot, :reboot_now, resource_name)
    end

    def request_reboot(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:reboot, :request_reboot, resource_name)
    end

    def cancel_reboot(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:reboot, :cancel, resource_name)
    end
  end
end
