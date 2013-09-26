module ChefSpec
  module Matchers
    define_resource_matchers([:create, :create_if_missing, :delete, :delete_key], [:registry_key])
  end
end
