ifconfig '10.0.0.1'

ifconfig '10.0.0.2' do
  action :add
end

ifconfig '10.0.0.3' do
  device 'en0'
end
