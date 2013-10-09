remote_directory '/tmp/default_action'

remote_directory '/tmp/explicit_action' do
  action :create
end

remote_directory '/tmp/with_attributes' do
  owner 'owner'
end

remote_directory 'specifying the identity attribute' do
  path '/tmp/identity_attribute'
end
