portage_package 'default_action'

portage_package 'explicit_action' do
  action :install
end

portage_package 'with_attributes' do
  version '1.0.0'
end

portage_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
