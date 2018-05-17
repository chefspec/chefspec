# XXX: This monkeypatch is somewhat terrible and dumps all of the
# resources in the sub-resource collection into the main resource
# collection.  Chefspec needs to be taught how to deal with
# sub-resource collections.

if defined?(Chef::Provider::InlineResources)
  Chef::Provider::InlineResources.prepend(Module.new do
    def initialize(resource, run_context)
      super
      @run_context = run_context
      @resource_collection = run_context.resource_collection
    end
  end)

  Chef::Provider::InlineResources::ClassMethods.prepend(Module.new do
    def action(name, &block)
      # Note: This does not check $CHEFSPEC_MODE.
      define_method("action_#{name}", &block)
    end
  end)
else # >= 13.0
  Chef::Provider.prepend(Module.new do
    def compile_and_converge_action(&block)
      return super unless $CHEFSPEC_MODE
      instance_eval(&block)
    end
  end)
end
