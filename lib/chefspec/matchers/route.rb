module ChefSpec
  module Matchers
    define_resource_matchers([:add, :delete], [:route])
  end
end
