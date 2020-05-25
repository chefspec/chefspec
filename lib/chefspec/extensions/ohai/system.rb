require 'ohai/system'

Ohai::System.prepend(Module.new do
  # If an Ohai segment exists, don't actually pull data in for ohai.
  # (we have fake data for that)
  # @see Ohai::System#run_additional_plugins
  def run_additional_plugins(plugin_path)
    return super unless $CHEFSPEC_MODE
    # noop
  end
end)
