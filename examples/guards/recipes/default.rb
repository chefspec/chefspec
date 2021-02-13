service 'true_guard' do
  action  :start
  only_if { 1 == 1 }
end

service 'false_guard' do
  action :start
  not_if { 1 == 1 }
end

service 'action_nothing_guard' do
  action :nothing
end
