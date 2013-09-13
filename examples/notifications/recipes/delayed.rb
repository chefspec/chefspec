template '/tmp/notifying_resource' do
  notifies :restart, 'service[receiving_resource]', :delayed
end

service 'receiving_resource' do
  action :nothing
end
