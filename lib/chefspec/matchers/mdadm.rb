module ChefSpec
  module Matchers
    define_resource_matchers([:create, :assemble, :stop], [:mdadm])
  end
end
