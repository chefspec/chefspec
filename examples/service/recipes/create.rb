service 'explicit_action' do
  action :nothing
end

service 'with_attributes' do
  pattern 'pattern'
  action :nothing
end

service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action      :nothing
end
