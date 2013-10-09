smartos_package 'default_action'

smartos_package 'explicit_action' do
  action :install
end

smartos_package 'with_attributes' do
  version '1.0.0'
end

smartos_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
