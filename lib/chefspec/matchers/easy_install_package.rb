module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove, :purge], [:easy_install_package])
  end
end
