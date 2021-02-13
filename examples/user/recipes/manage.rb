user 'explicit_action' do
  action :manage
end

user 'with_attributes' do
  uid    '1234'
  action :manage
end

user 'specifying the identity attribute' do
  username 'identity_attribute'
  action   :manage
end
