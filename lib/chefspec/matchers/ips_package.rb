module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove], [:ips_package])
  end
end
