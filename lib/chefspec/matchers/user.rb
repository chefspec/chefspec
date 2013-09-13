module ChefSpec
  module Matchers
    define_resource_matchers([:create, :remove, :modify, :manage, :lock, :unlock], [:user])
  end
end
