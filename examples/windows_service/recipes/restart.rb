windows_service 'explicit_action' do
  action :restart
end

windows_service 'with_attributes' do
  pattern 'pattern'
  action :restart
end

windows_service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :restart
end
