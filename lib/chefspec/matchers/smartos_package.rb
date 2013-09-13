module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove], [:smartos_package])
  end
end
