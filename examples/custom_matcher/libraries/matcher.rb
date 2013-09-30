module ChefSpec
  module API
    module CustomMatcherThingMatchers
      def install_custom_matcher_thing(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:custom_matcher_thing, :install, resource_name)
      end

      def remove_custom_matcher_thing(resource_name)
        ChefSpec::Matchers::ResourceMatcher.new(:custom_matcher_thing, :remove, resource_name)
      end
    end
  end
end
