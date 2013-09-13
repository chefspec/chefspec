module ChefSpec
  module Matchers
    define_resource_matchers([:deploy, :force_deploy, :rollback], [:deploy])
  end
end
