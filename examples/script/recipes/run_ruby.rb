ruby 'default_action'

ruby 'explicit_action' do
  action :run
end

ruby 'with_attributes' do
  creates 'creates'
end
