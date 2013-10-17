require 'chef/event_dispatch/base'

module ChefSpec
  class Reporter < ::Chef::EventDispatch::Base
    #
    # Called when a resource is converged ({Chef::Resource#run_action}).
    # This appends the action to the resource's +performed_actions+ so that
    # ChefSpec can assert the resource received the proper message.
    #
    # @param [Chef::Resource] resource
    #   the resource to report on
    # @param [Symbol] action
    #   the action
    #
    def resource_action_start(resource, action, notification_type = nil, notifier = nil)
      if @converging
        resource.perform_action(action, converge_time: true)
      else
        resource.perform_action(action, compile_time: true)
      end
    end

    #
    # Called when a resource action is skipped (due to a resource guard
    # or +action :nothing+). This removes the given action from the list
    # of +performed_actions+ on the resource.
    #
    # @param [Chef::Resource] resource
    #   the resource to report on
    # @param [Symbol] action
    #   the action
    # @param [Chef::Resource::Conditional] conditional
    #   the conditional that ran
    #
    def resource_skipped(resource, action, conditional)
      resource.unperform_action(action)
    end

    #
    # Called when we start convering. This method sets an instance variable
    # that other classes use to determine if a resource action was run during
    # compile time or converge time.
    #
    # @param [Chef::RunContext] run_context
    #   the Chef run context
    #
    def converge_start(run_context)
      @converging = true
    end
  end
end
