module ChefSpec
  module Matchers
    define_resource_matchers([:install, :remove], [:freebsd_package])
  end
end
