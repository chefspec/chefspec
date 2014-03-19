require 'chefspec'

describe 'library_gem::default' do
  it 'does not throws an error because of missing runner' do
    Chef::Resource.any_instance.stub(:old_run_action)
    ChefSpec::Runner.new.converge(described_recipe)
  end
end
