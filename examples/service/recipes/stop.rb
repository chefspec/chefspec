service 'explicit_action' do
  action :stop
end

service 'with_attributes' do
  pattern 'pattern'
  action :stop
end

service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :stop
end
