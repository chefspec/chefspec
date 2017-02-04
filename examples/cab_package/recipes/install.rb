cab_package 'default_action'

cab_package 'explicit_action' do
  action :install
end

cab_package 'with_attributes' do
  version '1.2.3'
end

cab_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
