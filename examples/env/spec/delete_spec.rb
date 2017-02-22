require 'chefspec'

describe 'env::delete' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'windows', version: '2012R2')
                          .converge(described_recipe)
  end

  it 'deletes a env with an explicit action' do
    expect(chef_run).to delete_env('explicit_action')
    expect(chef_run).to_not delete_env('not_explicit_action')
  end

  it 'deletes a env with attributes' do
    expect(chef_run).to delete_env('with_attributes').with(value: 'value')
    expect(chef_run).to_not delete_env('with_attributes').with(value: 'not_value')
  end

  it 'deletes a env when specifying the identity attribute' do
    expect(chef_run).to delete_env('identity_attribute')
  end
end
