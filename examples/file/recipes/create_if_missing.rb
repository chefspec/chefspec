file '/tmp/explicit_action' do
  action :create_if_missing
end

file '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :create_if_missing
end

file 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :create_if_missing
end
