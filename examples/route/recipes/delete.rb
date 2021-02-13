route '10.0.0.2' do
  action :delete
end

route '10.0.0.3' do
  gateway '10.0.0.0'
  action  :delete
end

route 'specifying the identity attribute' do
  target '10.0.0.4'
  action :delete
end
