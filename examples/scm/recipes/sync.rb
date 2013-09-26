scm '/tmp/default_action'

scm '/tmp/explicit_action' do
  action :sync
end

scm '/tmp/with_attributes' do
  repository 'ssh://scm.path'
end

scm 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
end
