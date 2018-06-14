resource_name :stubs_for_old

property :cmd
property :value
property :run_resource, [true, false], default: false
property :run_load, [true, false], default: false
property :run_provider, [true, false], default: false

def foo
  shell_out(cmd).stdout
end

action_class do
  def load_current_resource
    @current_resource = new_resource.class.new(new_resource.name)
    # current_resource.shell_out is weird but mostly doing it for completeness and parity checking with load_curent_value-style.
    @current_resource.value @current_resource.shell_out(new_resource.cmd).stdout if new_resource.run_load
    @current_resource
  end
end


action :run do
  new_resource.foo if new_resource.run_resource
  shell_out!(new_resource.cmd) if new_resource.run_provider
end
