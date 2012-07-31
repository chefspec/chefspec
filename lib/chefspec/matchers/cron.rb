require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete], [:cron], :name)
  end
end
