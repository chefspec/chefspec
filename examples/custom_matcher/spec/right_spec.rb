require 'chefspec'

describe 'custom_matcher::right' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'rights a custom_matcher with an explicit action' do
    expect(chef_run).to right_custom_matcher_thing('explicit_action')
  end

  it 'rights a custom_matcher with attributes' do
    expect(chef_run).to right_custom_matcher_thing('with_attributes').with(config: true)
  end

  it 'rights a custom_matcher when specifying the identity attribute' do
    expect(chef_run).to right_custom_matcher_thing('identity_attribute')
  end
end
