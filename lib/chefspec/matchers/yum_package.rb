module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove, :purge], [:yum_package])
  end
end
