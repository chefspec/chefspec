module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove, :purge], [:portage_package])
  end
end
