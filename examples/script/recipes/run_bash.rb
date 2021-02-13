bash 'default_action'

bash 'explicit_action' do
  action :run
end

bash 'with_attributes' do
  creates 'creates'
end
