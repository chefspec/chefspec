require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:install, :upgrade, :remove, :purge], [:python_pip], :name)
  end
end
