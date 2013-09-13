module ChefSpec
  module Matchers
    define_resource_matchers([:disable, :enable, :reload, :restart, :start, :stop], [:service])
  end
end
