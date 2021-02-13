registry_key 'HKEY_LOCAL_MACHINE\default_action'

registry_key 'HKEY_LOCAL_MACHINE\explicit_action' do
  action :create
end

registry_key 'HKEY_LOCAL_MACHINE\with_attributes' do
  recursive true
end

registry_key 'specifying the identity attribute' do
  key 'HKEY_LOCAL_MACHINE\identity_attribute'
end
