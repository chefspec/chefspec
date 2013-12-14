require 'chef/resource'

class Chef::Resource
  alias_method :old_initialize, :initialize
  def initialize(*args)
    @performed_actions = {}
    old_initialize(*args)
  end

  alias_method :old_run_action, :run_action
  def run_action(action, notification_type = nil, notifying_resource = nil)
    resolve_notification_references
    validate_action(action)

    Chef::Log.info("Processing #{self} action #{action} (#{defined_at})")

    ChefSpec::Coverage.add(self)

    unless should_skip?(action)
      if node.runner.step_into?(self)
        instance_eval { @not_if = []; @only_if = [] }
        old_run_action(action, notification_type, notifying_resource)
      end

      if node.runner.compiling?
        perform_action(action, compile_time: true)
      else
        perform_action(action, converge_time: true)
      end
    end
  end

  def perform_action(action, options = {})
    @performed_actions[action.to_sym] ||= {}
    @performed_actions[action.to_sym].merge!(options)
  end

  def performed_action(action)
    @performed_actions[action.to_sym]
  end

  def performed_action?(action)
    !!performed_action(action)
  end

  def performed_actions
    @performed_actions.keys
  end
end
