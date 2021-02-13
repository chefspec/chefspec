windows_service 'explicit_action' do
  action :disable
end

windows_service 'with_attributes' do
  pattern 'pattern'
  action :disable
end

windows_service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :disable
end
