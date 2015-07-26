require 'chefspec'

RSpec.configure do |config|
  config.platform = 'windows'
  config.version  = '2012R2'
end

describe 'env::delete' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

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
