log "node.environment=#{node.environment}"
log "node.chef_environment=#{node.chef_environment}"

begin
  log "node.foo=#{node.foo}"
rescue
end

if node.environment == '_default' || node.chef_environment == '_default'
  raise Chef::Exceptions::EnvironmentNotFound
end