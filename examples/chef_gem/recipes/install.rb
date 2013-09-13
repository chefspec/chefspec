chef_gem 'default_action'

chef_gem 'explicit_action' do
  action :install
end

chef_gem 'with_attributes' do
  version '1.0.0'
end

chef_gem 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
