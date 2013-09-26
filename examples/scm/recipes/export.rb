scm '/tmp/explicit_action' do
  action :export
end

scm '/tmp/with_attributes' do
  repository 'ssh://scm.path'
  action     :export
end

scm 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :export
end
