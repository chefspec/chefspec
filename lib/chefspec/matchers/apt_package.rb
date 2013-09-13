module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :reconfig, :remove, :purge], [:apt_package])
  end
end
