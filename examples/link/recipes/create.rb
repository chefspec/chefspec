link '/tmp/default_action'

link '/tmp/explicit_action' do
  action :create
end

link '/tmp/with_attributes' do
  to 'destination'
end

link 'specifying the identity attribute' do
  target_file '/tmp/identity_attribute'
end
