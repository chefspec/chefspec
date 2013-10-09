execute 'default_action'

execute 'explicit_action' do
  action :run
end

execute 'with_attributes' do
  user 'user'
end

execute 'specifying the identity attribute' do
  command 'identity_attribute'
end
