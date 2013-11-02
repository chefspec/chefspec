require 'chefspec'

ChefSpec::Runner.define_runner_method(:state_attrs_lwrp)

describe 'state_attrs::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:lwrp) { chef_run.state_attrs_lwrp('name') }

  it 'has the correct state attributes' do
    expect(lwrp).to have_state_attrs(:name, :time)
  end
end
