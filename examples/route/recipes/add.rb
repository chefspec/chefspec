route '10.0.0.1'

route '10.0.0.2' do
  action :add
end

route '10.0.0.3' do
  gateway '10.0.0.0'
end

route 'specifying the identity attribute' do
  target '10.0.0.4'
end
