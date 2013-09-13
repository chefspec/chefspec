module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete, :modify], [:env])
  end
end
