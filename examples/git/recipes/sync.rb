git '/tmp/default_action'

git '/tmp/explicit_action' do
  action :sync
end

git '/tmp/with_attributes' do
  repository 'ssh://git.path'
end

git 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
end
