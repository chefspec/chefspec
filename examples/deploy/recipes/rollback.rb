deploy '/tmp/explicit_action' do
  action :rollback
end

deploy '/tmp/with_attributes' do
  repo    'ssh://git.path'
  migrate true
  action  :rollback
end
