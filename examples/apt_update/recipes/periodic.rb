apt_repository 'default_action'

apt_update 'explicit_action' do
  action :periodic
end
