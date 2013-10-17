template 'template' do
  notifies :restart, 'service[service]'
end

service 'service' do
  action :nothing
  notifies :write, 'log[log]'
end

log 'log' do
  action :nothing
end
