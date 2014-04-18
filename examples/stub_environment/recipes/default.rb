log "node.environment=#{node.environment}"
log "node.chef_environment=#{node.chef_environment}"

log "node.foo=#{node.foo}" unless node['foo'].nil?

if node.environment == '_default' || node.chef_environment == '_default'
  raise StandardError, 'Environment not stubbed'
end
