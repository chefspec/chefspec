dpkg_package 'default_action'

dpkg_package 'explicit_action' do
  action :install
end

dpkg_package 'with_attributes' do
  version '1.0.0'
end

dpkg_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
