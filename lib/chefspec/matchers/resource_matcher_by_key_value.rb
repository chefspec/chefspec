module ChefSpec::Matchers
  class ResourceMatcherByKeyValue < ChefSpec::Matchers::ResourceMatcher
    def initialize(resource_name, expected_action, key, expected_value)
      @resource_name     = resource_name
      @expected_action   = expected_action
      @key               = key
      @expected_value    = expected_value
    end
    
    def description
      %Q{#{@expected_action} #{@resource_name} with #{@key} = "#{@expected_value}"}
    end

    private

    #
    # Find the resource in the Chef run by the given class name and
    # resource key/value.
    #
    # @see ChefSpec::Runner#find_resource
    #
    # @return [Chef::Resource, nil]
    #
    def resource
      @_resource ||= @runner.find_resource_by_key(@resource_name, @key, @expected_value)
    end
  end
end
