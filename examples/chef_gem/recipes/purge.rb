chef_gem 'explicit_action' do
  action       :purge
  compile_time false if respond_to?(:compile_time)
end

chef_gem 'with_attributes' do
  version      '1.0.0'
  action       :purge
  compile_time false if respond_to?(:compile_time)
end

chef_gem 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :purge
  compile_time false if respond_to?(:compile_time)
end
