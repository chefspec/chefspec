easy_install_package 'default_action'

easy_install_package 'explicit_action' do
  action :install
end

easy_install_package 'with_attributes' do
  version '1.0.0'
end

easy_install_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
