gem_package 'default_action'

gem_package 'explicit_action' do
  action :install
end

gem_package 'with_attributes' do
  version '1.0.0'
end

gem_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
