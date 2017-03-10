require 'chefspec'

describe 'yum_repository::add' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.3.1611')
                          .converge(described_recipe)
  end

  it 'creates a yum_repository with add action' do
    expect(chef_run).to add_yum_repository('explicit_add_action')
  end
end
