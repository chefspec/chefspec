module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove, :purge], [:pacman_package])
  end
end
