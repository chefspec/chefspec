require "chef/resource/service"

class ::Chef
  class Resource
    class HeavyProviderLightResourceService < ::Chef::Resource::Service
      provides :heavy_provider_light_resource_service

      attr_accessor :root
      def initialize(service_name, run_context = nil)
        super
        @resource_name = :mixed_resource
        @action = :configure
        @allowed_actions += [:configure]
      end
    end
  end
end
