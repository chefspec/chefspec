windows_service 'explicit_action' do
  action :start
end

windows_service 'with_attributes' do
  pattern 'pattern'
  action :start
end

windows_service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :start
end
