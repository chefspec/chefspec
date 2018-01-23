log 'default_action'

log 'explicit_action' do
  action :write
end

log 'with_attributes' do
  level :debug
end

log 'specifying the identity attribute' do
  message 'identity_attribute'
end
