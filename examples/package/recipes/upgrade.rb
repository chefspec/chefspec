package 'explicit_action' do
  action :upgrade
end

package 'with_attributes' do
  version '1.0.0'
  action  :upgrade
end

package 'specifying the identity attribute' do
  package_name 'identity_attribute'
  action       :upgrade
end

package %w(with array) do
  action :upgrade
end
