service 'test' do
  action :nothing
end

notifications 'update' do
  action :create
  notifies :restart, 'service[test]'
end

notifications 'nothing' do
  action :create
  notifies :restart, 'service[test]'
end
