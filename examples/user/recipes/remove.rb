user 'explicit_action' do
  action :remove
end

user 'with_attributes' do
  uid    '1234'
  action :remove
end

user 'specifying the identity attribute' do
  username 'identity_attribute'
  action   :remove
end
