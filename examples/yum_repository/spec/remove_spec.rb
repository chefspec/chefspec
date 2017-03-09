require 'chefspec'

describe 'yum_repository::remove' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.3.1611')
                          .converge(described_recipe)
  end

  it 'removes a yum_repository with remove action' do
    expect(chef_run).to remove_yum_repository('explicit_remove_action')
  end
end
