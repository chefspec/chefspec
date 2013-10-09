yum_package 'default_action'

yum_package 'explicit_action' do
  action :install
end

yum_package 'with_attributes' do
  version '1.0.0'
end

yum_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
