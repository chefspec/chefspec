apt_repository 'default_action' do
  uri 'some_uri'
end

apt_repository 'explicit_action' do
  uri 'some_url'
  action :add
end
