require 'chefspec'

describe 'custom_matcher::remove' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'removes a custom_matcher with an explicit action' do
    expect(chef_run).to remove_custom_matcher_thing('explicit_action')
  end

  it 'removes a custom_matcher with attributes' do
    expect(chef_run).to remove_custom_matcher_thing('with_attributes').with(config: true)
  end

  it 'removes a custom_matcher when specifying the identity attribute' do
    expect(chef_run).to remove_custom_matcher_thing('identity_attribute')
  end

  it 'defines a runner method' do
    expect(chef_run).to respond_to(:custom_matcher_thing)
  end
end
