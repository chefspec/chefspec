cron 'default_action'

cron 'explicit_action' do
  action :create
end

cron 'with_attributes' do
  minute '0'
  hour   '20'
end
