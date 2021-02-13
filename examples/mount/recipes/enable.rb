mount '/tmp/explicit_action' do
  action :enable
end

mount '/tmp/with_attributes' do
  dump   3
  action :enable
end
