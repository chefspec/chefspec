macports_package 'default_action'

macports_package 'explicit_action' do
  action :install
end

macports_package 'with_attributes' do
  version '1.0.0'
end

macports_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
