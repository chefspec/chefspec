package 'default_action'

package 'explicit_action' do
  action :install
end

package 'with_attributes' do
  version '1.0.0'
end

package 'specifying the identity attribute' do
  package_name 'identity_attribute'
end

package %w(with array) do
  action :install
end
