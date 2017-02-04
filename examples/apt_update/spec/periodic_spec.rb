require 'chefspec'

describe 'apt_update::periodic' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'updates apt with default action' do
    expect(chef_run).to periodic_apt_update('default_action')
    expect(chef_run).to_not periodic_apt_update('not_default_action')
  end

  it 'installs an apt_repository with an explicit action' do
    expect(chef_run).to periodic_apt_update('explicit_action')
  end
end
