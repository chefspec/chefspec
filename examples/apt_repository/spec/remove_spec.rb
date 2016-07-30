require 'chefspec'

describe 'apt_repository::remove' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'removes a apt_repository with default action' do
    expect(chef_run).to remove_apt_repository('explicit_remove_action')
  end
end
