subversion '/tmp/explicit_action' do
  action :checkout
end

subversion '/tmp/with_attributes' do
  repository 'ssh://subversion.path'
  action     :checkout
end

subversion 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :checkout
end
