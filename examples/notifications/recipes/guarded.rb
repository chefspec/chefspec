execute 'reload' do
  command 'true'
  action :nothing
end

# The guard stops the action from running, so Chef never delivers the
# notification.
file '/tmp/guarded' do
  action :delete
  notifies :run, 'execute[reload]', :immediately
  only_if { 1 == 2 }
end

# An unguarded resource for comparison.
file '/tmp/unguarded' do
  action :delete
  notifies :run, 'execute[reload]', :immediately
end
