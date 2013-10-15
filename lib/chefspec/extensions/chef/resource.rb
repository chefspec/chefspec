require 'chef/resource'

class Chef::Resource
  alias :old_run_action :run_action unless method_defined?(:old_run_action)

  #
  # Pretend to run resource actions, adding them to the resource collection
  # to prevent actually executing resources
  #
  # @see Chef::Resource#run_action
  #
  def run_action(action, notification_type = nil, notifying_resource = nil)
    return if should_skip?(action)

    if node.runner.step_into.include?(self.resource_name.to_s)
      instance_eval { @not_if = []; @only_if = [] }
      old_run_action(action, notification_type, notifying_resource)
    end

    if node.runner.compiling?
      @compile_time = true
    end

    Chef::Log.info("Processing #{self} action #{action} (#{defined_at})")

    # Append the currently run action to the existing resource actions,
    # making sure it's a unique array of symbols.
    @action = [self.action, action].flatten.compact.map(&:to_sym).uniq
    node.runner.resources[self.to_s] ||= self
  end

  #
  # Determine if the current resource is a compile-time resource (as opposed
  # to a converge time resource). Compile-time resources are executed with the
  # +run_action+ command at load time, rather than at comverge time.
  #
  # @return [Boolean]
  #
  def compile_time?
    !!@compile_time
  end
end
