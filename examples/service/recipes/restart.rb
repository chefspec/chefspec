service 'explicit_action' do
  action :restart
end

service 'with_attributes' do
  pattern 'pattern'
  action :restart
end

service 'specifying the identity attribute' do
  service_name 'identity_attribute'
  action :restart
end
