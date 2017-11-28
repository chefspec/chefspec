package 'explicit_action' do
  action :unlock
end

package 'with_attributes' do
  version '1.0.0'
  action  :unlock
end

package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :unlock
end

package %w(with array) do
  action :unlock
end
