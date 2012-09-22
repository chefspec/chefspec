
require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete,:modify], [:env], :key_name)
  end
end
