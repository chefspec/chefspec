mdadm 'explicit_action' do
  action :stop
end

mdadm 'with_attributes' do
  chunk  8
  action :stop
end

mdadm 'specifying the identity attribute' do
  raid_device 'identity_attribute'
  action      :stop
end
