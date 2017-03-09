require 'chefspec'

describe 'yum_repository::create' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.3.1611')
                          .converge(described_recipe)
  end

  it 'create a yum_repository with default action' do
    expect(chef_run).to create_yum_repository('default_action')
    expect(chef_run).to_not create_yum_repository('not_default_action')
  end

  it 'creates a yum_repository with create action' do
    expect(chef_run).to create_yum_repository('explicit_action')
  end
end
