custom_matcher_thing 'explicit_action' do
  action :right
end

custom_matcher_thing 'with_attributes' do
  config true
  action :right
end

custom_matcher_thing 'specifying the identity attribute' do
  name   'identity_attribute'
  action :right
end
