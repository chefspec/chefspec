template '/tmp/notifying_resource' do
  notifies :restart, 'service[receiving_resource]', :immediately
end

service 'receiving_resource' do
  action :nothing
end
