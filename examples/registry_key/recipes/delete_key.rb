registry_key 'HKEY_LOCAL_MACHINE\explicit_action' do
  action :delete_key
end

registry_key 'HKEY_LOCAL_MACHINE\with_attributes' do
  recursive true
  action    :delete_key
end

registry_key 'specifying the identity attribute' do
  key    'HKEY_LOCAL_MACHINE\identity_attribute'
  action :delete_key
end
