require 'rspec'

require_relative 'chefspec/extensions/chef/client'
require_relative 'chefspec/extensions/chef/conditional'
require_relative 'chefspec/extensions/chef/data_query'
require_relative 'chefspec/extensions/chef/lwrp_base'
require_relative 'chefspec/extensions/chef/resource'
require_relative 'chefspec/extensions/chef/securable'

require_relative 'chefspec/mixins/normalize'

require_relative 'chefspec/stubs/command_registry'
require_relative 'chefspec/stubs/command_stub'
require_relative 'chefspec/stubs/data_bag_item_registry'
require_relative 'chefspec/stubs/data_bag_item_stub'
require_relative 'chefspec/stubs/data_bag_registry'
require_relative 'chefspec/stubs/data_bag_stub'
require_relative 'chefspec/stubs/registry'
require_relative 'chefspec/stubs/stub'
require_relative 'chefspec/stubs/search_registry'
require_relative 'chefspec/stubs/search_stub'

require_relative 'chefspec/api'
require_relative 'chefspec/coverage'
require_relative 'chefspec/errors'
require_relative 'chefspec/expect_exception'
require_relative 'chefspec/formatter'
require_relative 'chefspec/macros'
require_relative 'chefspec/matchers'
require_relative 'chefspec/renderer'
require_relative 'chefspec/rspec'
require_relative 'chefspec/runner'
require_relative 'chefspec/util'
require_relative 'chefspec/version'

module ChefSpec
  extend self

  #
  # The source root of the ChefSpec gem. This is useful when requiring files
  # that are relative to the root of the project.
  #
  # @return [Pathname]
  #
  def root
    @root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end
end
