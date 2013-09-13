module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :reconfig, :remove, :purge], [:gem_package])
  end
end
