module ChefSpec
  module Matchers
    SCRIPT_TYPES = [
      :bash,
      :csh,
      :perl,
      :python,
      :ruby,
      :script,
    ]

    define_resource_matchers([:run], SCRIPT_TYPES)
  end
end
