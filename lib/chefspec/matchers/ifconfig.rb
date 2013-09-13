module ChefSpec
  module Matchers
    define_resource_matchers([:add, :delete, :enable, :disable], [:ifconfig])
  end
end
