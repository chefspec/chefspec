cab_package 'explicit_action' do
  action :remove
end

cab_package 'with_attributes' do
  version '1.2.3'
  action  :remove
end

cab_package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :remove
end
