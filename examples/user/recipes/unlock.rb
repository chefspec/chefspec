user 'explicit_action' do
  action :unlock
end

user 'with_attributes' do
  uid    '1234'
  action :unlock
end

user 'specifying the identity attribute' do
  username 'identity_attribute'
  action   :unlock
end
