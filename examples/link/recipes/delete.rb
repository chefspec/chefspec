link '/tmp/explicit_action' do
  action :delete
end

link '/tmp/with_attributes' do
  to     'destination'
  action :delete
end

link 'specifying the identity attribute' do
  target_file '/tmp/identity_attribute'
  action      :delete
end
