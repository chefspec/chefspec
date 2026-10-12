require "chef/resource"
require "chef/version"
require_relative "../../api"

#
# Three concerns:
#   - no-op'ing so that the action does not run the provider
#   - tracking the actions that were performed
#   - auto registering helper methods
#

module ChefSpec::Extensions::Chef::Resource

  #
  # Hooks for the stubs_for system
  #
  def initialize(*args, &block)
    super(*args, &block)
    if $CHEFSPEC_MODE
      # Here be dragons.
      # If we're directly inside a `load_current_resource`, this is probably
      # something like `new_resource.class.new` so we want to call this a current_resource,
      # Otherwise it's probably a normal resource instantiation.
      mode = :resource
      mode = :current_value if caller.any? { |x| x.include?("`load_current_resource'") || x.include?("`load_after_resource'") || x.include?("`load_current_value'") || x.include?("load_current_value") || x.include?("load_current_resource") }
      ChefSpec::API::StubsFor.setup_stubs_for(self, mode)
    end
  end

  #
  # Duplicate the resource, re-registering +stubs_for+ hooks when the copy is
  # being made on behalf of +load_current_value+.
  #
  # @return [Chef::Resource]
  #
  def dup
    return super unless $CHEFSPEC_MODE

    # Also here be dragons.
    super.tap do |dup_resource|
      # We're directly inside a load_current_resource, which is probably via
      # the load_current_value DSL system, so call this a current resource.
      ChefSpec::API::StubsFor.setup_stubs_for(dup_resource, :current_value) if caller.any? { |x| x.include?("`load_current_resource'") || x.include?("`load_after_resource'") }
    end
  end

  # mix of no-op and tracking concerns
  def run_action(action, notification_type = nil, notifying_resource = nil)
    return super unless $CHEFSPEC_MODE

    resolve_notification_references
    validate_action(action)

    Chef::Log.info("Processing #{self} action #{action} (#{defined_at})")

    ChefSpec::Coverage.add(self)

    if should_skip?(action)
      # should_skip? is also true for `action :nothing`, via Chef's
      # ConditionalActionNotNothing, which is not a guard refusing to run the
      # resource. Only record real guard skips so that matchers can tell the
      # two apart.
      perform_skipped_action(action) unless action.to_sym == :nothing
    else
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

  def perform_action(action, options = {})
    @performed_actions ||= {}
    @performed_actions[action.to_sym] ||= {}
    @performed_actions[action.to_sym].merge!(options)
  end

  #
  # The options recorded when the resource performed the given action.
  #
  # @param [Symbol, String] action
  #   the action to look up
  #
  # @return [Hash, nil]
  #   the recorded options, or +nil+ if the action was never performed
  #
  def performed_action(action)
    @performed_actions ||= {}
    @performed_actions[action.to_sym]
  end

  def performed_action?(action)
    if action == :nothing
      performed_actions.empty?
    else
      !!performed_action(action)
    end
  end

  #
  # Every action the resource performed during the Chef run.
  #
  # @return [Array<Symbol>]
  #
  def performed_actions
    @performed_actions ||= {}
    @performed_actions.keys
  end

  #
  # Record that a guard refused the given action, so notifications from the
  # skipped action are not reported as having fired.
  #
  # @param [Symbol, String] action
  #   the action the guard refused
  #
  # @return [Array<Symbol>]
  #   every action the guard has refused so far
  #
  def perform_skipped_action(action)
    @skipped_actions ||= []
    @skipped_actions |= [action.to_sym]
  end

  #
  # The actions that did not run because a guard refused them.
  #
  # @return [Array<Symbol>]
  #
  def skipped_actions
    @skipped_actions ||= []
  end

  #
  # auto-registration
  #

  def self.prepended(base)
    class << base
      prepend ClassMethods
    end
  end

  #
  # Prepended onto every resource's singleton class so that declaring a
  # resource name, provides line, or action automatically defines the
  # matching ChefSpec matcher.
  #
  # This is what makes +create_my_resource("foo")+ work for a custom resource
  # without any extra registration.
  #
  module ClassMethods
    # XXX: kind of a crappy way to find all the names of a resource
    def provides_names
      @provides_names ||= []
    end

    #
    # Record the resource name and define matchers for its allowed actions.
    #
    # @param [Symbol] name
    #   the resource name being declared
    #
    # @return [Symbol]
    #
    def resource_name(name = ::Chef::NOT_PASSED)
      unless name == ::Chef::NOT_PASSED
        provides_names << name unless provides_names.include?(name)
        inject_actions(*allowed_actions)
      end
      super
    end

    #
    # Record the provided name and define matchers for its allowed actions.
    #
    # @param [Symbol] name
    #   the resource name being provided
    #
    # @param [Hash] options
    #   the platform filters passed through to Chef
    #
    # @return [void]
    #
    def provides(name, **options, &block)
      provides_names << name unless provides_names.include?(name)
      inject_actions(*allowed_actions)
      super
    end

    #
    # Define an action and its corresponding ChefSpec matcher.
    #
    # @param [Symbol] sym
    #   the action being defined
    #
    # @param [String, nil] description
    #   the action description passed through to Chef
    #
    # @return [void]
    #
    def action(sym, description: nil, &block)
      inject_actions(sym)
      super(sym, &block)
    end

    #
    # Declare allowed actions and define matchers for each of them.
    #
    # @param [Array<Symbol>] actions
    #   the actions to allow
    #
    # @return [Array<Symbol>]
    #
    def allowed_actions(*actions)
      inject_actions(*actions) unless actions.empty?
      super
    end

    #
    # Replace the allowed actions and define matchers for each of them.
    #
    # @param [Array<Symbol>, Symbol] value
    #   the actions to allow
    #
    # @return [Array<Symbol>]
    #
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
        next unless resource_name

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
