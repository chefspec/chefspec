if defined?(ChefSpec)
  module ChefSpec
    module Matchers
      define_resource_matchers([:left, :right], [:custom_matcher_thing])
    end
  end
end
