package 'explicit_action' do
  action :reconfig
end

package 'with_attributes' do
  version '1.0.0'
  action  :reconfig
end

package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :reconfig
end

package %w(with array) do
  action :reconfig
end
