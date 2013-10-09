remote_directory '/tmp/explicit_action' do
  action :delete
end

remote_directory '/tmp/with_attributes' do
  owner 'owner'
  action :delete
end

remote_directory 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :delete
end
