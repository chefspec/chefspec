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

  alias_method :old_method_missing, :method_missing
  def method_missing(method_name, *arguments, &block)
    if method_name.to_s =~ /has_(.*)\?/
      send($1) == arguments.first
    else
      old_method_missing(method_name, *arguments, &block)
    end
  end

  alias_method :old_respond_to?, :respond_to?
  def respond_to?(method_name, include_private = false)
    method_name.to_s =~ /has_(.*)\?/ || old_respond_to?(method_name, include_private)
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
  alias_method :has_performed_action?, :performed_action?

  def performed_actions
    @performed_actions.keys
  end
end
