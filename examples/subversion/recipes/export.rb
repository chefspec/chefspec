subversion '/tmp/explicit_action' do
  action :export
end

subversion '/tmp/with_attributes' do
  repository 'ssh://subversion.path'
  action     :export
end

subversion 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :export
end
