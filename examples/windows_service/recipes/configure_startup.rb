windows_service 'explicit_action' do
  action :configure_startup
end

windows_service 'with_attributes' do
  pattern 'pattern'
  action :configure_startup
end

windows_service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :configure_startup
end
