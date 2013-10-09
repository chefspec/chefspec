require 'chefspec'

describe 'attributes::default' do
  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['attributes']['message'] = 'The new message is here'
    end.converge(described_recipe)
  end

  it 'uses the overriden node attribute' do
    expect(chef_run).to write_log('The new message is here')
    expect(chef_run).to_not write_log('The old message is here')
  end
end
