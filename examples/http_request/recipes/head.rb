http_request 'explicit_action' do
  action :head
end

http_request 'with_attributes' do
  url    'http://my.url'
  action :head
end

http_request 'specifying the identity attribute' do
  url    'identity_attribute'
  action :head
end
