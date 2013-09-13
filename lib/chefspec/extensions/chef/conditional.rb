require 'chef/resource/conditional'

class Chef::Resource::Conditional
  # @override Chef::Resource::Conditional#evaluate_command
  def evaluate_command
    stub = ChefSpec::Stubs::CommandRegistry.stub_for(@command)
    raise ChefSpec::CommandNotStubbedError.new(@command) if stub.nil?

    stub.result
  end
end
