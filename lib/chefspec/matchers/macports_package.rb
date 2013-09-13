module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove, :purge], [:macports_package])
  end
end
