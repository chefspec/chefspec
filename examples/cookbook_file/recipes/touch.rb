cookbook_file '/tmp/explicit_action' do
  action :touch
end

cookbook_file '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :touch
end

cookbook_file 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :touch
end
