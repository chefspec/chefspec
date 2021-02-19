group 'explicit_action' do
  action :modify
end

group 'with_attributes' do
  gid    1234
  action :modify
end

group 'specifying the identity attribute' do
  group_name 'identity_attribute'
  action     :modify
end
