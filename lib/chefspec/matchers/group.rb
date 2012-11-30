
require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:create, :remove], [:group], :group_name)
  end
end
