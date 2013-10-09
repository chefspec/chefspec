git '/tmp/explicit_action' do
  action :checkout
end

git '/tmp/with_attributes' do
  repository 'ssh://git.path'
  action     :checkout
end

git 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :checkout
end
