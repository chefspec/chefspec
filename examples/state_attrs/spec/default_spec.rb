require 'chefspec'

ChefSpec.define_matcher(:state_attrs_lwrp)

describe 'state_attrs::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }
  let(:lwrp) { chef_run.state_attrs_lwrp('name') }

  it 'has the correct state attributes' do
    expect(lwrp).to have_state_attrs(:name, :time)
  end
end
