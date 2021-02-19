http_request 'explicit_action' do
  action :options
end

http_request 'with_attributes' do
  url    'http://my.url'
  action :options
end

http_request 'specifying the identity attribute' do
  url    'identity_attribute'
  action :options
end
