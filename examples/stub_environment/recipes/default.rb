if node.environment == '_default' || node.chef_environment == '_default'
  raise Chef::Exceptions::EnvironmentNotFound
end