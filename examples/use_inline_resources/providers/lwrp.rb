use_inline_resources

action :run do
  package('package') { action :install }
  service('service') { action :start }
  template('template') { action :create }
end
