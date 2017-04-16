module ChefSpec::Matchers
  class IncludeResourceMatcher
    def initialize(resource_name)
      @resource_name = resource_name
    end

    def matches?(chef_run)
      @chef_run = chef_run
      unique_resources.include?(@resource_name.to_sym)
    end

    def failure_message_for_should
      "expected #{unique_resources.join(' ')} to include #{@resource_name}"
    end

    def failure_message_for_should_not
      "expected #{unique_resources.join(' ')} to not include #{@resource_name}"
    end

    def description
      "include resource #{@resource_name}"
    end

    private

    def unique_resources
      @chef_run.resource_collection.map { |r| r.resource_name }.uniq
    end
  end
end
