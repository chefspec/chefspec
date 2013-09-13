module ChefSpec
  module Matchers
    define_resource_matchers([:get, :put, :post, :delete, :head, :options], [:http_request])
  end
end
