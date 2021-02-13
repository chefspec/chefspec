http_request 'default_action'

http_request 'explicit_action' do
  action :get
end

http_request 'with_attributes' do
  url 'http://my.url'
end

http_request 'specifying the identity attribute' do
  url 'identity_attribute'
end
