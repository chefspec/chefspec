module ChefSpec::Matchers
  #
  # Asserts that a resource subscribed to another resource.
  #
  # Built by {ChefSpec::API::Subscriptions#subscribe_to}. Subscriptions are the
  # inverse of notifications, so this matcher resolves the resource being
  # subscribed to and delegates the actual check to {NotificationsMatcher}.
  #
  # @example
  #   expect(chef_run.service("apache2")).to subscribe_to("template[/etc/foo]")
  #     .on(:restart).delayed
  #
  class SubscribesMatcher
    include ChefSpec::Normalize

    #
    # Create a new matcher for the given resource signature.
    #
    # @param [String] signature
    #   the subscribed-to resource in +type[name]+ form, such as
    #   +"template[/etc/foo]"+
    #
    def initialize(signature)
      match = signature.match(/^([^\[]*)\[(.*)\]$/)
      @expected_resource_type = match[1]
      @expected_resource_name = match[2]
    end

    #
    # Determine whether the resource subscribed to the expected resource.
    #
    # @param [Chef::Resource] resource
    #   the subscribing resource
    #
    # @return [true, false]
    #
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

    #
    # Restrict the match to subscriptions for a specific action.
    #
    # @param [Symbol, String] action
    #   the action the subscription must send, such as +:restart+
    #
    # @return [self]
    #
    def on(action)
      @action = action
      self
    end

    #
    # Restrict the match to immediate subscriptions.
    #
    # @return [self]
    #
    def immediately
      @immediately = true
      self
    end

    #
    # Restrict the match to delayed subscriptions.
    #
    # @return [self]
    #
    def delayed
      @delayed = true
      self
    end

    #
    # Restrict the match to +before+ subscriptions.
    #
    # @return [self]
    #
    def before
      @before = true
      self
    end

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      @instance.description
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
    def failure_message
      @instance.failure_message
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      @instance.failure_message_when_negated
    end
  end
end
