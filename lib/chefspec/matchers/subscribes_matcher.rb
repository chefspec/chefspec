module ChefSpec::Matchers
  class SubscribesMatcher
    include ChefSpec::Normalize

    def initialize(signature)
      signature.match(/^([^\[]*)\[(.*)\]$/)
      @expected_resource_type = $1
      @expected_resource_name = $2
    end

    def matches?(resource)
      @instance = ChefSpec::Matchers::NotificationsMatcher.new(resource.to_s)

      if @action
        @instance.to(@action)
      end

      if @immediately
        @instance.immediately
      end

      if @delayed
        @instance.delayed
      end

      if @before
        @instance.before
      end

      if resource
        runner   = resource.run_context.node.runner
        expected = runner.find_resource(@expected_resource_type, @expected_resource_name)

        @instance.matches?(expected)
      else
        @instance.matches?(nil)
      end
    end

    def on(action)
      @action = action
      self
    end

    def immediately
      @immediately = true
      self
    end

    def delayed
      @delayed = true
      self
    end

    def before
      @before = true
      self
    end

    def description
      @instance.description
    end

    def failure_message
      @instance.failure_message
    end

    def failure_message_when_negated
      @instance.failure_message_when_negated
    end
  end
end
