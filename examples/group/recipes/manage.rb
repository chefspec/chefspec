group 'explicit_action' do
  action :manage
end

group 'with_attributes' do
  gid    1234
  action :manage
end

group 'specifying the identity attribute' do
  group_name 'identity_attribute'
  action     :manage
end
