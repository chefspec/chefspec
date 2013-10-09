http_request 'explicit_action' do
  action :post
end

http_request 'with_attributes' do
  url    'http://my.url'
  action :post
end

http_request 'specifying the identity attribute' do
  url    'identity_attribute'
  action :post
end
