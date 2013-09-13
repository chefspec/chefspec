module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete], [:cron])
  end
end
