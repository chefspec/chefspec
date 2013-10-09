template '/tmp/default_action'

template '/tmp/explicit_action' do
  action :create
end

template '/tmp/with_attributes' do
  user   'user'
  group  'group'
  backup false
end

template 'specifying the identity attribute' do
  path '/tmp/identity_attribute'
end
