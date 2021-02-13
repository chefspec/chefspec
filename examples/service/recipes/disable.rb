service 'explicit_action' do
  action :disable
end

service 'with_attributes' do
  pattern 'pattern'
  action :disable
end

service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :disable
end
