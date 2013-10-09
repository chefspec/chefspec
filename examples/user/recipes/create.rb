user 'default_action'

user 'explicit_action' do
  action :create
end

user 'with_attributes' do
  uid '1234'
end

user 'specifying the identity attribute' do
  username 'identity_attribute'
end
