mdadm 'explicit_action' do
  action :assemble
end

mdadm 'with_attributes' do
  chunk  8
  action :assemble
end

mdadm 'specifying the identity attribute' do
  raid_device 'identity_attribute'
  action      :assemble
end
