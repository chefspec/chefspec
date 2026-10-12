module ChefSpec::Matchers
  #
  # Asserts that a resource notified another resource.
  #
  # Built by {ChefSpec::API::Notifications#notify}. By default any notification
  # to the target resource matches; chain {#to}, {#immediately}, {#delayed}, or
  # {#before} to narrow the assertion.
  #
  # @example
  #   expect(chef_run.template("/etc/foo")).to notify("service[apache2]")
  #     .to(:restart).delayed
  #
  class NotificationsMatcher
    include ChefSpec::Normalize

    #
    # Create a new matcher for the given resource signature.
    #
    # @param [String] signature
    #   the notified resource in +type[name]+ form, such as
    #   +"service[apache2]"+
    #
    def initialize(signature)
      match = signature.match(/^([^\[]*)\[(.*)\]$/)
      @expected_resource_type = match[1]
      @expected_resource_name = match[2]
    end

    #
    # Determine whether the resource sent a matching notification.
    #
    # Only the notification timing selected by {#immediately}, {#delayed}, or
    # {#before} is searched; with none of them set, all timings are searched.
    #
    # @param [Chef::Resource] resource
    #   the notifying resource
    #
    # @return [true, false]
    #
    def matches?(resource)
      @resource = resource

      if @resource
        # Notifications stay declared on a resource even when a guard stopped
        # its action from running, but Chef only delivers them when the action
        # actually runs. This deliberately does not cover `action :nothing`
        # resources, which still notify when they are themselves notified.
        return false if @resource.performed_actions.empty? && @resource.skipped_actions.any?

        block = proc do |notified|
          resource_name(notified.resource).to_s == @expected_resource_type &&
            (@expected_resource_name === notified.resource.identity.to_s || @expected_resource_name === notified.resource.name.to_s) &&
            matches_action?(notified)
        end

        if @immediately
          immediate_notifications.any?(&block)
        elsif @delayed
          delayed_notifications.any?(&block)
        elsif @before
          before_notifications.any?(&block)
        else
          all_notifications.any?(&block)
        end
      end
    end

    #
    # Restrict the match to notifications sending a specific action.
    #
    # @param [Symbol, String] action
    #   the action the notification must send, such as +:restart+
    #
    # @return [self]
    #
    def to(action)
      @action = action.to_sym
      self
    end

    #
    # Restrict the match to immediate notifications.
    #
    # @return [self]
    #
    def immediately
      @immediately = true
      self
    end

    #
    # Restrict the match to delayed notifications.
    #
    # @return [self]
    #
    def delayed
      @delayed = true
      self
    end

    #
    # Restrict the match to +before+ notifications.
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
      message = %Q{notify "#{@expected_resource_type}[#{@expected_resource_name}]"}
      message << " with action :#{@action}" if @action
      message << " immediately" if @immediately
      message << " delayed" if @delayed
      message << " before" if @before
      message
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # Lists every notification the resource actually sent, which is usually
    # enough to spot a wrong action or timing.
    #
    # @return [String]
    #
    def failure_message
      if @resource
        message = %Q{expected "#{@resource}" to notify "#{@expected_resource_type}[#{@expected_resource_name}]"}
        message << " with action :#{@action}" if @action
        message << " immediately" if @immediately
        message << " delayed" if @delayed
        message << " before" if @before
        message << ", but did not."
        message << "\n\n"
        message << "Other notifications were:\n\n#{format_notifications}"
        message << "\n "
        message
      else
        message = %Q{expected _something_ to notify "#{@expected_resource_type}[#{@expected_resource_name}]"}
        message << " with action :#{@action}" if @action
        message << " immediately" if @immediately
        message << " delayed" if @delayed
        message << " before" if @before
        message << ", but the _something_ you gave me was nil! If you are running a test like:"
        message << "\n\n"
        message << "  expect(_something_).to notify('...')"
        message << "\n\n"
        message << "Make sure that `_something_` exists, because I got nil"
        message << "\n "
        message
      end
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      if @resource
        message = %Q{expected "#{@resource}" to not notify "#{@expected_resource_type}[#{@expected_resource_name}]"}
        message << ", but it did."
        message
      end
    end

    private

    def all_notifications
      immediate_notifications + delayed_notifications + before_notifications
    end

    def immediate_notifications
      @resource.immediate_notifications
    end

    def delayed_notifications
      @resource.delayed_notifications
    end

    def before_notifications
      @resource.before_notifications
    end

    def matches_action?(notification)
      return true if @action.nil?

      @action == notification.action.to_sym
    end

    def format_notification(notification)
      notifying_resource = notification.notifying_resource
      resource = notification.resource

      if notifying_resource.immediate_notifications.include?(notification)
        type = :immediately
      elsif notifying_resource.before_notifications.include?(notification)
        type = :before
      else
        type = :delayed
      end

      %Q{  "#{notifying_resource}" notifies "#{resource_name(resource)}[#{resource.name}]" to :#{notification.action}, :#{type}}
    end

    def format_notifications
      all_notifications.map do |notification|
        "  " + format_notification(notification)
      end.join("\n")
    end
  end
end
