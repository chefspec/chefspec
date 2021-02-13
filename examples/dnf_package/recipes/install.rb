dnf_package 'default_action'

dnf_package 'explicit_action' do
  action :install
end

dnf_package 'with_attributes' do
  version '1.0.0'
end

dnf_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
