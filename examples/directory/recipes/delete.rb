directory '/tmp/explicit_action' do
  action :delete
end

directory '/tmp/with_attributes' do
  user   'user'
  group  'group'
  action :delete
end

directory 'specifying the identity attribute' do
  path '/tmp/identity_attribute'
  action :delete
end
