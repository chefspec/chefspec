mount '/tmp/default_action'

mount '/tmp/explicit_action' do
  action :mount
end

mount '/tmp/with_attributes' do
  dump 3
end
