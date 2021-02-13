template '/tmp/explicit_action' do
  action :touch
end

template '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :touch
end

template 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :touch
end
