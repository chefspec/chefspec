module ChefSpec
  module Matchers
    define_resource_matchers([:install, :remove], [:solaris_package])
  end
end
