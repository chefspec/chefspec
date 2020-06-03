require 'chef/resource'
require 'chef/version'
require_relative '../../api'

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
      mode = :current_value if caller.any? { |x| x.include?("`load_current_resource'") || x.include?("`load_after_resource'") }
      ChefSpec::API::StubsFor.setup_stubs_for(self, mode)
    end
  end

  def dup
    return super unless $CHEFSPEC_MODE
    # Also here be dragons.
    stack = caller
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
  # Defang shell_out and friends so it can never run.
  #
  if ChefSpec::API::StubsFor::HAS_SHELLOUT_COMPACTED.satisfied_by?(Gem::Version.create(Chef::VERSION))
    def shell_out_compacted(*args)
      return super unless $CHEFSPEC_MODE
      raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: 'resource', resource: self)
    end

    def shell_out_compacted!(*args)
      return super unless $CHEFSPEC_MODE
      shell_out_compacted(*args).tap {|c| c.error! }
    end
  else
    def shell_out(*args)
      return super unless $CHEFSPEC_MODE
      raise ChefSpec::Error::ShellOutNotStubbed.new(args: args, type: 'resource', resource: self)
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

  def performed_actions
    @performed_actions ||= {}
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

    def provides(name, **options, &block)
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
