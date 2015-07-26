windows_package 'explicit_action' do
  action :install
end

windows_package 'with_attributes' do
  installer_type :msi
  action :install
end

windows_package 'specifying the identity attribute' do
  name 'identity_attribute'
  action :install
end
