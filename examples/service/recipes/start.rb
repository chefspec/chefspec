service 'explicit_action' do
  action :start
end

service 'with_attributes' do
  pattern 'pattern'
  action :start
end

service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :start
end
