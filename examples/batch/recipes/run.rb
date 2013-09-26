batch 'default_action'

batch 'explicit_action' do
  action :run
end

batch 'with_attributes' do
  flags '-f'
end

batch 'specifying the identity attribute' do
  command 'identity_attribute'
end
