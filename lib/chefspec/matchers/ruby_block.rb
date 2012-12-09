require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:create], [:ruby_block], :name)
  end
end