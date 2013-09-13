remote_file '/tmp/default_action' do
  source 'http://not-real'
end

remote_file '/tmp/explicit_action' do
  source 'http://not-real'
  action :create
end

remote_file '/tmp/with_attributes' do
  source 'http://not-real'
  owner 'owner'
end

remote_file 'specifying the identity attribute' do
  source 'http://not-real'
  path '/tmp/identity_attribute'
end
