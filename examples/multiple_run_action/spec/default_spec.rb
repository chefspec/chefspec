require 'chefspec'

describe 'multiple_run_action::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }
  let(:actions) { chef_run.template('/tmp/resource').action }

  it 'returns an array of symbols' do
    expect(actions).to be_a(Array)
    Array(actions).each do |action|
      expect(action).to be_a(Symbol)
    end
  end

  it 'includes the action explicitly given to the resource' do
    expect(actions).to include(:create)
  end

  it 'includes an action specific called in #run_action' do
    expect(actions).to include(:touch)
  end
end
