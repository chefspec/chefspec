user 'explicit_action' do
  action :modify
end

user 'with_attributes' do
  uid    '1234'
  action :modify
end

user 'specifying the identity attribute' do
  username 'identity_attribute'
  action   :modify
end
