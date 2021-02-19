provides :custom_resource

property :name, name_property: true

action :run do
  package('package') { action :install }
  service('service') { action :start }
  template('template') { action :create }
end
