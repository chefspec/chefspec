ohai 'default_action'

ohai 'explicit_action' do
  action :reload
end

ohai 'with_attributes' do
  plugin 'plugin'
end

ohai 'specifying the identity attribute' do
  name 'identity_attribute'
end
