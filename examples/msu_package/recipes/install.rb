msu_package 'default_action'

msu_package 'explicit_action' do
  action :install
end

msu_package 'with_attributes' do
  version '1.0.0'
end

msu_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
