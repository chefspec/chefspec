
require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:create, :remove], [:user], :username)
  end
end
