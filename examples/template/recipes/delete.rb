template '/tmp/explicit_action' do
  action :delete
end

template '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :delete
end

template 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :delete
end
