zypper_package 'default_action'

zypper_package 'explicit_action' do
  action :install
end

zypper_package 'with_attributes' do
  version '1.0.0'
end

zypper_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
