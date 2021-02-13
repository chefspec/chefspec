remote_file '/tmp/explicit_action' do
  source 'http://not-real'
  action :delete
end

remote_file '/tmp/with_attributes' do
  source 'http://not-real'
  owner  'owner'
  action :delete
end

remote_file 'specifying the identity attribute' do
  source 'http://not-real'
  path   '/tmp/identity_attribute'
  action :delete
end
