service 'explicit_action' do
  action :enable
end

service 'with_attributes' do
  pattern 'pattern'
  action :enable
end

service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :enable
end
