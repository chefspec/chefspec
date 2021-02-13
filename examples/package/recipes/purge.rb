package 'explicit_action' do
  action :purge
end

package 'with_attributes' do
  version '1.0.0'
  action  :purge
end

package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :purge
end

package %w(with array) do
  action :purge
end
