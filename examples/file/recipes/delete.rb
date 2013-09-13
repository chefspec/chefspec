file '/tmp/explicit_action' do
  action :delete
end

file '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :delete
end

file 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :delete
end
