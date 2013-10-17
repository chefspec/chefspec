require 'chef/provider'

class Chef::Provider
  alias_method :old_run_action, :run_action unless method_defined?(:old_run_action)

  def run_action(action = nil)
    Chef::Log.debug("Running action '#{action}' for #{self} (skipping because ChefSpec)")
    @new_resource.updated_by_last_action(true)

    if node.runner.step_into.include?(@new_resource.resource_name.to_s)
      Chef::Log.debug("Stepping into LWRP #{@new_resource.resource_name.to_s}")

      if whyrun_supported?
        Chef::Log.warn("#{self} does not support whyrun mode. This could be dangerous!")
      end

      old_run_action(action)
    end
  end
end
