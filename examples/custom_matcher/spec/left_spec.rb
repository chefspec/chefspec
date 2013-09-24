require 'chefspec'

describe 'custom_matcher::left' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'lefts a custom_matcher with the default action' do
    expect(chef_run).to left_custom_matcher_thing('default_action')
  end

  it 'lefts a custom_matcher with an explicit action' do
    expect(chef_run).to left_custom_matcher_thing('explicit_action')
  end

  it 'lefts a custom_matcher with attributes' do
    expect(chef_run).to left_custom_matcher_thing('with_attributes').with(config: true)
  end

  it 'lefts a custom_matcher when specifying the identity attribute' do
    expect(chef_run).to left_custom_matcher_thing('identity_attribute')
  end
end
