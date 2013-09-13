module ChefSpec
  module Matchers
    #
    # Assert that a resource notifies another.
    #
    # @example Assert the template notifies apache of something
    #   template = chef_run.template('/etc/apache2.conf')
    #   expect(template).to notify('service[apache2]')
    #
    # @example Assert the template notifies apache to restart
    #   expect(template).to notify('service[apache2]').to(:restart)
    #
    # @example Assert the template notifies apache to restart immediately
    #   expect(template).to notify('service[apache2]').to(:restart).immediately
    #
    # @example Assert the template notifies apache to restart delayed
    #   expect(template).to notify('service[apache2]').to(:restart).delayed
    #
    RSpec::Matchers.define(:notify) do |expected_resource|
      expected_resource.match(/^([^\[]*)\[(.*)\]$/)
      expected_resource_type = $1
      expected_resource_name = $2

      match do |resource|
        block = Proc.new do |notified|
          notified.resource.resource_name.to_s == expected_resource_type &&
          notified.resource.name.to_s == expected_resource_name &&
          matches_action?(notified)
        end

        if @immediately
          immediate_notifications(resource).any?(&block)
        elsif @delayed
          delayed_notifications(resource).any?(&block)
        else
          all_notifications(resource).any?(&block)
        end
      end

      chain(:to) do |action|
        @action = action.to_sym
      end

      chain(:immediately) do
        @immediately = true
      end

      chain(:delayed) do
        @delayed = true
      end

      failure_message_for_should do |resource|
        message = "expected '#{resource.resource_name}[#{resource.name}]' to notify '#{expected_resource}'"
        message << " with action #{@action.inspect}"

        if @immediately
          message << " immediately"
        elsif @delayed
          message << " delayed"
        end

        message << ", but did not. Other notifications were:\n#{format_notifications(resource)}"
        message
      end

      #
      # Helper to list all notifications for a resource
      #
      # @param [Chef::Resource] resource
      #
      # @return [Array<Chef::Resource>]
      #
      def all_notifications(resource)
        immediate_notifications(resource) + delayed_notifications(resource)
      end

      #
      # Helper to list all immediate notifications for a resource
      #
      # @param [Chef::Resource] resource
      #
      # @return [Array<Chef::Resource>]
      #
      def immediate_notifications(resource)
        resource.immediate_notifications
      end

      #
      # Helper to list all delayed notifications for a resource
      #
      # @param [Chef::Resource] resource
      #
      # @return [Array<Chef::Resource>]
      #
      def delayed_notifications(resource)
        resource.delayed_notifications
      end

      #
      # Helper method to determine if the given resource matches the
      # expected actions.
      #
      # @param [Chef::Resource] resource
      #
      # @return [Boolean]
      #
      def matches_action?(notification)
        return true if @action.nil?
        @action == notification.action.to_sym
      end

      #
      # Format a single notification for display to the user.
      #
      # @param [Chef::Resource::Notification]
      #
      # @return [String]
      def format_notification(notification)
        resource = notification.resource
        type = immediate_notifications(notification.notifying_resource).include?(notification) ? :immediately : :delayed

        "notifies :#{notification.action}, '#{resource.resource_name}[#{resource.name}]', :#{type}"
      end

      #
      # Format all notifications for a resource.
      #
      # @param [Chef::Resource]
      #
      # @return [String]
      #
      def format_notifications(resource)
        all_notifications(resource).map do |notification|
          '  ' + format_notification(notification)
        end.join("\n")
      end
    end
  end
end
