openbsd_package 'default_action'

openbsd_package 'explicit_action' do
  action :install
end

openbsd_package 'with_attributes' do
  version '1.0.0'
end

openbsd_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
