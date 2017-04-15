template '/tmp/notifying_resource_with_not_if_true' do
  not_if { true }
  notifies :restart, 'service[receiving_resource]'
end

template '/tmp/notifying_resource_with_not_if_false' do
  not_if { false }
  notifies :restart, 'service[receiving_resource]'
end

template '/tmp/notifying_resource_with_only_if_false' do
  only_if { false }
  notifies :restart, 'service[receiving_resource]'
end

template '/tmp/notifying_resource_with_only_if_true' do
  only_if { true }
  notifies :restart, 'service[receiving_resource]'
end

service 'receiving_resource' do
  action :nothing
end
