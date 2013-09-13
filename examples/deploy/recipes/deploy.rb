deploy '/tmp/default_action'

deploy '/tmp/explicit_action' do
  action :deploy
end

deploy '/tmp/with_attributes' do
  repo    'ssh://git.path'
  migrate true
end
