ifconfig '10.0.0.2' do
  action :enable
end

ifconfig '10.0.0.3' do
  device 'en0'
  action :enable
end
