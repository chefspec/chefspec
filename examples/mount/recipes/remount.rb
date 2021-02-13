mount '/tmp/explicit_action' do
  action :remount
end

mount '/tmp/with_attributes' do
  dump   3
  action :remount
end
