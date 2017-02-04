require 'chefspec'

describe 'env::modify' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'modifies a env with an explicit action' do
    expect(chef_run).to modify_env('explicit_action')
    expect(chef_run).to_not modify_env('not_explicit_action')
  end

  it 'modifies a env with attributes' do
    expect(chef_run).to modify_env('with_attributes').with(value: 'value')
    expect(chef_run).to_not modify_env('with_attributes').with(value: 'not_value')
  end

  it 'modifies a env when specifying the identity attribute' do
    expect(chef_run).to modify_env('identity_attribute')
  end
end
