module ChefSpec
  module Matchers
    define_resource_matchers([:left, :right, :up, :down], [:custom_matcher_thing])
  end
end
