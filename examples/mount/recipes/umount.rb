mount '/tmp/explicit_action' do
  action :umount
end

mount '/tmp/with_attributes' do
  dump   3
  action :umount
end
