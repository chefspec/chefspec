env 'explicit_action' do
  action :delete
end

env 'with_attributes' do
  value  'value'
  action :delete
end

env 'specifying the identity attribute' do
  key_name 'identity_attribute'
  action   :delete
end
