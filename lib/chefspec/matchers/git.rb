module ChefSpec
  module Matchers
    define_resource_matchers([:checkout, :export, :sync], [:git])
  end
end
