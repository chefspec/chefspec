registry_key 'HKEY_LOCAL_MACHINE\explicit_action' do
  action :delete
end

registry_key 'HKEY_LOCAL_MACHINE\with_attributes' do
  recursive true
  action    :delete
end

registry_key 'specifying the identity attribute' do
  key    'HKEY_LOCAL_MACHINE\identity_attribute'
  action :delete
end
