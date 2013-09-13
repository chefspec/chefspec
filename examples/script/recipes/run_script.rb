script 'default_action'

script 'explicit_action' do
  action :run
end

script 'with_attributes' do
  creates 'creates'
end

script 'specifying the identity attribute' do
  command 'identity_attribute'
end
