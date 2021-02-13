require 'chef/resource/service'

class ::Chef
  class Resource
    class HeavyProviderLightResourceService < ::Chef::Resource::Service
      provides :heavy_provider_light_resource_service

      attr_accessor :root
      resource_name :mixed_resource
      provides :mixed_resource

      default_action :configure

      def initialize(service_name, run_context = nil)
        super
        @allowed_actions += [:configure]
      end
    end
  end
end
