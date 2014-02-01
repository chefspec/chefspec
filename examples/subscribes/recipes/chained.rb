template 'template'

service 'service' do
  subscribes :create, 'template[template]'
end

log 'log' do
  subscribes :restart, 'service[service]'
  action :nothing
end
