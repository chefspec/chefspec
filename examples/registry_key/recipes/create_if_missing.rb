registry_key 'HKEY_LOCAL_MACHINE\explicit_action' do
  action :create_if_missing
end

registry_key 'HKEY_LOCAL_MACHINE\with_attributes' do
  recursive true
  action    :create_if_missing
end

registry_key 'specifying the identity attribute' do
  key    'HKEY_LOCAL_MACHINE\identity_attribute'
  action :create_if_missing
end
