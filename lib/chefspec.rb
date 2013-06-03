require 'chef'
require 'chef/formatters/chefspec'
require 'chefspec/chef_runner'
require 'chefspec/version'

if defined?(RSpec)
  require 'chefspec/matchers/cron'
  require 'chefspec/matchers/execute'
  require 'chefspec/matchers/file'
  require 'chefspec/matchers/link'
  require 'chefspec/matchers/log'
  require 'chefspec/matchers/package'
  require 'chefspec/matchers/ruby_block'
  require 'chefspec/matchers/service'
  require 'chefspec/matchers/shared'
  require 'chefspec/matchers/notifications'
  require 'chefspec/matchers/file_content'
  require 'chefspec/matchers/user'
  require 'chefspec/matchers/group'
  require 'chefspec/matchers/env'
  require 'chefspec/matchers/include_recipe'
  require 'chefspec/matchers/script'

  require 'chefspec/helpers/describe'
  RSpec.configure do |c|
    c.include ChefSpec::Helpers::Describe
  end
end

require 'chefspec/minitest'
require 'chefspec/monkey_patches/conditional'
require 'chefspec/monkey_patches/hash'
require 'chefspec/monkey_patches/lwrp_base'
require 'chefspec/monkey_patches/provider'
