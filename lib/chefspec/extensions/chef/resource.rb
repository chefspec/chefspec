require 'chef/resource'
require 'chefspec/api'

#
# Three concerns:
#   - no-op'ing so that the action does not run the provider
#   - tracking the actions that were performed
#   - auto registering helper methods
#

module ChefSpec::Extensions::Chef::Resource

  # mix of no-op and tracking concerns
  def run_action(action, notification_type = nil, notifying_resource = nil)
    resolve_notification_references
    validate_action(action)

    Chef::Log.info("Processing #{self} action #{action} (#{defined_at})")

    ChefSpec::Coverage.add(self)

    unless should_skip?(action)
      if node.runner.step_into?(self)
        instance_eval { @not_if = []; @only_if = [] }
        super
      end

      if node.runner.compiling?
        perform_action(action, compile_time: true)
      else
        perform_action(action, converge_time: true)
      end
    end
  end

  #
  # tracking
  #

  def initialize(*args)
    @performed_actions = {}
    super
  end

  def perform_action(action, options = {})
    @performed_actions[action.to_sym] ||= {}
    @performed_actions[action.to_sym].merge!(options)
  end

  def performed_action(action)
    @performed_actions[action.to_sym]
  end

  def performed_action?(action)
    if action == :nothing
      performed_actions.empty?
    else
      !!performed_action(action)
    end
  end

  def performed_actions
    @performed_actions.keys
  end

  #
  # auto-registration
  #

  def self.prepended(base)
    class << base
      prepend ClassMethods
    end
  end

  module ClassMethods
    # XXX: kind of a crappy way to find all the names of a resource
    def provides_names
      @provides_names ||= []
    end

    def resource_name(name = ::Chef::NOT_PASSED)
      unless name == ::Chef::NOT_PASSED
        provides_names << name unless provides_names.include?(name)
        inject_actions(*allowed_actions)
      end
      super
    end

    def provides(name, *args, &block)
      provides_names << name unless provides_names.include?(name)
      inject_actions(*allowed_actions)
      super
    end

    def action(sym, &block)
      inject_actions(sym)
      super
    end

    def allowed_actions(*actions)
      inject_actions(*actions) unless actions.empty?
      super
    end

    def allowed_actions=(value)
      inject_actions(*Array(value))
      super
    end

    private

    def inject_method(method, resource_name, action)
      unless ChefSpec::API.respond_to?(method)
        ChefSpec::API.send(:define_method, method) do |name|
          ChefSpec::Matchers::ResourceMatcher.new(resource_name, action, name)
        end
      end
    end

    def inject_actions(*actions)
      provides_names.each do |resource_name|
        ChefSpec.define_matcher(resource_name)
        actions.each do |action|
          inject_method(:"#{action}_#{resource_name}", resource_name, action)
          if action == :create_if_missing
            inject_method(:"create_#{resource_name}_if_missing", resource_name, action)
          end
        end
      end
    end
  end
end

Chef::Resource.prepend(ChefSpec::Extensions::Chef::Resource)
