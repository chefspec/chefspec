cron 'explicit_action' do
  action :delete
end

cron 'with_attributes' do
  minute '0'
  hour   '20'
  action :delete
end
