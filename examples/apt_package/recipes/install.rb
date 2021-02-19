apt_package 'default_action'

apt_package 'explicit_action' do
  action :install
end

apt_package 'with_attributes' do
  version '1.0.0'
end

apt_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
