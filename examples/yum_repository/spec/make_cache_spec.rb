require 'chefspec'

describe 'yum_repository::make_cache' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'centos', version: '7.2.1511')
                        .converge(described_recipe)
  end

  it 'makes cache for a yum_repository' do
    expect(chef_run).to make_cache_yum_repository('explicit_make_cache_action')
  end
end
