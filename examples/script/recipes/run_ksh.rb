ksh 'default_action'

ksh 'explicit_action' do
  action :run
end

ksh 'with_attributes' do
  creates 'creates'
end

ksh 'specifying the identity attribute' do
  command 'identity_attribute'
end
