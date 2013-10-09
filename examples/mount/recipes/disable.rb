mount '/tmp/explicit_action' do
  action :disable
end

mount '/tmp/with_attributes' do
  dump   3
  action :disable
end
