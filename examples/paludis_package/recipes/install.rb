paludis_package 'default_action'

paludis_package 'explicit_action' do
  action :install
end

paludis_package 'with_attributes' do
  version '1.0.0'
end

paludis_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end
