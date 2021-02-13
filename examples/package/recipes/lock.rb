package 'explicit_action' do
  action :lock
end

package 'with_attributes' do
  version '1.0.0'
  action  :lock
end

package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :lock
end

package %w(with array) do
  action :lock
end
