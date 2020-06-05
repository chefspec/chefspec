cron 'default_action' do
  command "/bin/true"
end

cron 'explicit_action' do
  command "/bin/true"
  action :create
end

cron 'with_attributes' do
  minute '0'
  hour   '20'
  command "/bin/true"
end
