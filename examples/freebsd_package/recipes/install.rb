freebsd_package 'default_action'

freebsd_package 'explicit_action' do
  action :install
end

freebsd_package 'with_attributes' do
  version '1.0.0'
end

freebsd_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
