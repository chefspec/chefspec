module ChefSpec
  module Matchers
    define_resource_matchers([:mount, :umount, :remount, :enable, :disable], [:mount])
  end
end
