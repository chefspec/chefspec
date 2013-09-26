module ChefSpec
  module Matchers
    define_resource_matchers([:checkout, :export, :sync], [:scm])
  end
end
