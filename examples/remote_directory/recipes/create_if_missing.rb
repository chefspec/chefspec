remote_directory '/tmp/explicit_action' do
  action :create_if_missing
end

remote_directory '/tmp/with_attributes' do
  owner 'owner'
  action :create_if_missing
end

remote_directory 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :create_if_missing
end
