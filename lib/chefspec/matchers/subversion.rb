module ChefSpec
  module Matchers
    define_resource_matchers([:checkout, :export, :force_export, :sync], [:subversion])
  end
end
