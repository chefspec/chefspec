ifconfig '10.0.0.2' do
  action :disable
end

ifconfig '10.0.0.3' do
  device 'en0'
  action :disable
end
