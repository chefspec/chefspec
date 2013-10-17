require 'chef/resource'

class Chef::Resource
  alias_method :old_initialize, :initialize

  def initialize(*args)
    @performed_actions = {}
    old_initialize(*args)
  end

  def perform_action(action, options = {})
    @performed_actions[action.to_sym] ||= {}
    @performed_actions[action.to_sym].merge!(options)
  end

  def unperform_action(action)
    @performed_actions.delete(action.to_sym)
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
