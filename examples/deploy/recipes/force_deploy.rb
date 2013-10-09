deploy '/tmp/explicit_action' do
  action :force_deploy
end

deploy '/tmp/with_attributes' do
  repo    'ssh://git.path'
  migrate true
  action  :force_deploy
end
