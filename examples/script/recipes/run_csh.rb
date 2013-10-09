csh 'default_action'

csh 'explicit_action' do
  action :run
end

csh 'with_attributes' do
  creates 'creates'
end

csh 'specifying the identity attribute' do
  command 'identity_attribute'
end
