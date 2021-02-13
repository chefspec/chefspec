subversion '/tmp/default_action'

subversion '/tmp/explicit_action' do
  action :sync
end

subversion '/tmp/with_attributes' do
  repository 'ssh://subversion.path'
end

subversion 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
end
