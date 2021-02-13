group 'explicit_action' do
  action :remove
end

group 'with_attributes' do
  gid    1234
  action :remove
end

group 'specifying the identity attribute' do
  group_name 'identity_attribute'
  action     :remove
end
