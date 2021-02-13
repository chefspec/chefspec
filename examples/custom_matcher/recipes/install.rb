custom_matcher_thing 'default_action'

custom_matcher_thing 'explicit_action' do
  action :install
end

custom_matcher_thing 'with_attributes' do
  config true
end

custom_matcher_thing 'specifying the identity attribute' do
  name 'identity_attribute'
end
