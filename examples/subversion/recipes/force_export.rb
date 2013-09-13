subversion '/tmp/explicit_action' do
  action :force_export
end

subversion '/tmp/with_attributes' do
  repository 'ssh://subversion.path'
  action     :force_export
end

subversion 'specifying the identity attribute' do
  destination '/tmp/identity_attribute'
  action      :force_export
end
