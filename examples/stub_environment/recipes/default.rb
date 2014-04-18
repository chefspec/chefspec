log "node.environment=#{node.environment}"
log "node.chef_environment=#{node.chef_environment}"
if node.environment == '_default' || node.chef_environment == '_default'
  raise Chef::Exceptions::EnvironmentNotFound
end