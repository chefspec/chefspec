rpm_package 'default_action'

rpm_package 'explicit_action' do
  action :install
end

rpm_package 'with_attributes' do
  version '1.0.0'
end

rpm_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
