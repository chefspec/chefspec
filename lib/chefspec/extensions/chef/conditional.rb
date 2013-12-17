require 'chef/resource/conditional'

class Chef::Resource::Conditional
  # @see Chef::Resource::Conditional#evaluate_command
  def evaluate_command
    stub = ChefSpec::Stubs::CommandRegistry.stub_for(@command)

    if stub.nil?
      raise ChefSpec::Error::CommandNotStubbed.new(args: [@command])
    end

    stub.result
  end
end
