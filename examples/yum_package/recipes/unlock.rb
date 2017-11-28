yum_package 'explicit_action' do
  action :unlock
end

yum_package 'with_attributes' do
  version '1.0.0'
  action  :unlock
end

yum_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :unlock
end
