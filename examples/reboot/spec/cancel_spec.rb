require 'chefspec'

describe 'reboot::cancel' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'runs a cancel_reboot' do
    expect(chef_run).to cancel_reboot('explicit cancel')
  end
end
