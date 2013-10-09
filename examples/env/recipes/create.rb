env 'default_action'

env 'explicit_action' do
  action :create
end

env 'with_attributes' do
  value 'value'
end

env 'specifying the identity attribute' do
  key_name 'identity_attribute'
end
