file '/tmp/default_action'

file '/tmp/explicit_action' do
  action :create
end

file '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
end

file 'specifying the identity attribute' do
  path '/tmp/identity_attribute'
end
