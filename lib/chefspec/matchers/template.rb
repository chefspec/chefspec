module ChefSpec
  module Matchers
    define_resource_matchers([:create, :create_if_missing, :delete, :touch], [:template])
  end
end
