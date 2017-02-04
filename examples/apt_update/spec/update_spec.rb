require 'chefspec'

describe 'apt_update::update' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04')
                          .converge(described_recipe)
  end

  it 'updates apt repo' do
    expect(chef_run).to update_apt_update('update_repo')
  end
end
