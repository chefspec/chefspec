ruby 'default_action'

ruby 'explicit_action' do
  action :run
end

ruby 'with_attributes' do
  creates 'creates'
end

ruby 'specifying the identity attribute' do
  command 'identity_attribute'
end
