cookbook_file '/tmp/default_action'

cookbook_file '/tmp/explicit_action' do
  action :create
end

cookbook_file '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
end

cookbook_file 'specifying the identity attribute' do
  path '/tmp/identity_attribute'
end
