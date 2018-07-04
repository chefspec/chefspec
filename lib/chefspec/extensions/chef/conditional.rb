require 'chef/resource/conditional'

Chef::Resource::Conditional.prepend(Module.new do
  # @see Chef::Resource::Conditional#evaluate_command
  def evaluate_command
    return super unless $CHEFSPEC_MODE
    stub = ChefSpec::Stubs::CommandRegistry.stub_for(@command)

    if stub.nil?
      raise ChefSpec::Error::CommandNotStubbed.new(args: [@command])
    end

    stub.result
  end
end)
