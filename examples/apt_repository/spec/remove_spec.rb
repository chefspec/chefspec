require 'chefspec'

describe 'apt_repository::remove' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'removes a apt_repository with default action' do
    expect(chef_run).to remove_apt_repository('explicit_remove_action')
  end
end
