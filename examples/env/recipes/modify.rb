env 'explicit_action' do
  action :modify
end

env 'with_attributes' do
  value  'value'
  action :modify
end

env 'specifying the identity attribute' do
  key_name 'identity_attribute'
  action   :modify
end
