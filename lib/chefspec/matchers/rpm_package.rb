module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove], [:rpm_package])
  end
end
