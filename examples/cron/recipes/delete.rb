cron "explicit_action" do
  command "/bin/true"
  action :delete
end

cron "with_attributes" do
  minute "0"
  hour   "20"
  command "/bin/true"
  action :delete
end
