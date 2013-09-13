module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :reconfig, :remove, :purge], [:package])
  end
end
