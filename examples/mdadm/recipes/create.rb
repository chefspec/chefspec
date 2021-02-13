mdadm 'default_action'

mdadm 'explicit_action' do
  action :create
end

mdadm 'with_attributes' do
  chunk 8
end

mdadm 'specifying the identity attribute' do
  raid_device 'identity_attribute'
end
