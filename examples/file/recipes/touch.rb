file '/tmp/explicit_action' do
  action :touch
end

file '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :touch
end

file 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :touch
end
