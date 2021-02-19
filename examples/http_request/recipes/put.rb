http_request 'explicit_action' do
  action :put
end

http_request 'with_attributes' do
  url    'http://my.url'
  action :put
end

http_request 'specifying the identity attribute' do
  url    'identity_attribute'
  action :put
end
