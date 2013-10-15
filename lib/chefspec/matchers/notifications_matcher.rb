module ChefSpec::Matchers
  class NotificationsMatcher
    def initialize(signature)
      signature.match(/^([^\[]*)\[(.*)\]$/)
      @expected_resource_type = $1
      @expected_resource_name = $2
    end

    def matches?(resource)
      @resource = resource

      block = Proc.new do |notified|
        notified.resource.resource_name.to_s == @expected_resource_type &&
        (@expected_resource_name === notified.resource.identity.to_s || @expected_resource_name === notified.resource.name.to_s) &&
        matches_action?(notified)
      end

      if @immediately
        immediate_notifications.any?(&block)
      elsif @delayed
        delayed_notifications.any?(&block)
      else
        all_notifications.any?(&block)
      end
    end

    def to(action)
      @action = action.to_sym
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

    def description
      message = "notify #{@expected_resource_type}[#{@expected_resource_name}]"
      message << " with action #{@action.inspect}" if @action
      message << " immediately" if @immediately
      message << " delayed" if @delayed
      message
    end

    def failure_message_for_should
      message = "expected '#{@resource.resource_name}[#{@resource.name}]' to notify '#{@expected_resource_type}[#{@expected_resource_name}]'"
      message << " with action #{@action.inspect}" if @action
      message << " immediately" if @immediately
      message << " delayed" if @delayed
      message << ", but did not."
      message << "\n\n"
      message << "Other notifications were:\n#{format_notifications}"
      message << "\n "
      message
    end

    private
      def all_notifications
        immediate_notifications + delayed_notifications
      end

      def immediate_notifications
        @resource.immediate_notifications
      end

      def delayed_notifications
        @resource.delayed_notifications
      end

      def matches_action?(notification)
        return true if @action.nil?
        @action == notification.action.to_sym
      end

      def format_notification(notification)
        resource = notification.resource
        type = notification.notifying_resource.immediate_notifications.include?(notification) ? :immediately : :delayed

        "notifies :#{notification.action}, '#{resource.resource_name}[#{resource.name}]', :#{type}"
      end

      def format_notifications
        all_notifications.map do |notification|
          '  ' + format_notification(notification)
        end.join("\n")
      end
  end
end
