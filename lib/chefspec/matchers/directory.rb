module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete], [:directory])
  end
end
