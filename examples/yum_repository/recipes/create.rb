yum_repository 'default_action' do
  baseurl 'some_uri'
end

yum_repository 'explicit_action' do
  baseurl 'some_url'
  action :create
end
