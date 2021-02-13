group 'default_action'

group 'explicit_action' do
  action :create
end

group 'with_attributes' do
  gid 1234
end

group 'specifying the identity attribute' do
  group_name 'identity_attribute'
end
