resource_name :stubs_for_test
provides :stubs_for_test

property :cmd
property :value
property :run_resource, [true, false], default: false
property :run_load, [true, false], default: false
property :run_provider, [true, false], default: false
property :user, default: nil

def foo
  shell_out(cmd).stdout
end

load_current_value do |new_resource|
  value shell_out(new_resource.cmd).stdout if new_resource.run_load
end

action :run do
  new_resource.foo if new_resource.run_resource
  if new_resource.run_provider
    if new_resource.user
      shell_out!(new_resource.cmd, user: new_resource.user)
    else
      shell_out!(new_resource.cmd)
    end
  end
end
