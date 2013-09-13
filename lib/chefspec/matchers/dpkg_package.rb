module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :reconfig, :remove, :purge], [:dpkg_package])
  end
end
