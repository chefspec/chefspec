require 'chefspec'

describe 'yum_repository::delete' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511')
                        .converge(described_recipe)
  end

  it 'deletes a yum_repository with default action' do
    expect(chef_run).to delete_yum_repository('explicit_delete_action')
  end
end
