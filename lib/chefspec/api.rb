module ChefSpec
  module API
    # empty container
  end
end

# non-resources
require_relative 'api/do_nothing'
require_relative 'api/include_recipe'
require_relative 'api/notifications'
require_relative 'api/render_file'
require_relative 'api/state_attrs'
require_relative 'api/subscriptions'

# hacks and sugar for resources that don't follow the normal pattern
require_relative 'api/user'
require_relative 'api/link'
require_relative 'api/reboot'
