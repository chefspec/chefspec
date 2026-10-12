# XXX: This monkeypatch is somewhat terrible and dumps all of the
# resources in the sub-resource collection into the main resource
# collection.  Chefspec needs to be taught how to deal with
# sub-resource collections.

Chef::Provider.prepend(Module.new do
  def compile_and_converge_action(&block)
    return super unless $CHEFSPEC_MODE

    instance_eval(&block)
  end
end)
