scm '/tmp/explicit_action' do
  action :checkout
end

scm '/tmp/with_attributes' do
  repository 'ssh://scm.path'
  action     :checkout
end

scm 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :checkout
end
