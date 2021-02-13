template '/tmp/explicit_action' do
  action :create_if_missing
end

template '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
  action :create_if_missing
end

template 'specifying the identity attribute' do
  path   '/tmp/identity_attribute'
  action :create_if_missing
end
