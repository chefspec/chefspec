require 'chefspec'

describe 'env::create' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'creates a env with the default action' do
    expect(chef_run).to create_env('default_action')
    expect(chef_run).to_not create_env('not_default_action')
  end

  it 'creates a env with an explicit action' do
    expect(chef_run).to create_env('explicit_action')
  end

  it 'creates a env with attributes' do
    expect(chef_run).to create_env('with_attributes').with(value: 'value')
    expect(chef_run).to_not create_env('with_attributes').with(value: 'not_value')
  end

  it 'creates a env when specifying the identity attribute' do
    expect(chef_run).to create_env('identity_attribute')
  end
end
