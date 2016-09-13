require 'chefspec'

describe 'yum_repository::remove' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511')
                        .converge(described_recipe)
  end

  it 'removes a yum_repository with default action' do
    expect(chef_run).to remove_yum_repository('explicit_remove_action')
  end
end
