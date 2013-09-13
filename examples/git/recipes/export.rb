git '/tmp/explicit_action' do
  action :export
end

git '/tmp/with_attributes' do
  repository 'ssh://git.path'
  action     :export
end

git 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :export
end
