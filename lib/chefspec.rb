require 'rspec'

module ChefSpec
  #
  # Defines a new runner method on the Chef runner.
  #
  # @param [Symbol] resource_name
  #   the name of the resource to define a method
  #
  # @return [self]
  #
  def define_matcher(resource_name)
    matchers[resource_name.to_sym] = Proc.new do |identity|
      find_resource(resource_name, identity)
    end

    self
  end
  module_function :define_matcher

  #
  # The source root of the ChefSpec gem. This is useful when requiring files
  # that are relative to the root of the project.
  #
  # @return [Pathname]
  #
  def root
    @root ||= Pathname.new(File.expand_path('../../', __FILE__))
  end
  module_function :root

  protected

  #
  # The list of custom defined matchers.
  #
  # @return [Hash<String, Proc>]
  #
  def matchers
    @matchers ||= {}
  end
  module_function :matchers
end

require_relative 'chefspec/extensions'

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
require_relative 'chefspec/cacher'
require_relative 'chefspec/coverage'
require_relative 'chefspec/errors'
require_relative 'chefspec/expect_exception'
require_relative 'chefspec/formatter'
require_relative 'chefspec/macros'
require_relative 'chefspec/matchers'
require_relative 'chefspec/renderer'
require_relative 'chefspec/rspec'
require_relative 'chefspec/server_runner'
require_relative 'chefspec/solo_runner'
require_relative 'chefspec/util'
require_relative 'chefspec/version'

require_relative 'chefspec/deprecations'
