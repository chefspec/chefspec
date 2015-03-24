directory '/tmp/default_action'

directory '/tmp/explicit_action' do
  action :create
end

directory '/tmp/with_attributes' do
  user   'user'
  group  'group'
end

directory 'specifying the identity attribute' do
  path '/tmp/identity_attribute'
end

directory 'c:\temp\with_windows_rights' do
  rights :read_execute, 'Users', applies_to_children: true
end
