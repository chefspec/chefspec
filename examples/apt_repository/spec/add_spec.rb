require 'chefspec'

describe 'apt_repository::add' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'adds a apt_repository with default action' do
    expect(chef_run).to add_apt_repository('default_action')
    expect(chef_run).to_not add_apt_repository('not_default_action')
  end

  it 'installs a apt_repository with an explicit action' do
    expect(chef_run).to add_apt_repository('explicit_action')
  end
end
