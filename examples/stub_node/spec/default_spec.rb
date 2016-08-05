require 'chefspec'

describe 'stub_node::default' do
  let(:my_node) do
    stub_node('example.com', platform: 'ubuntu', version: '14.04') do |node|
      node.normal['foo']['bar'] = 'zip'
    end
  end

  it 'sets the fauxhai attributes' do
    expect(my_node['kernel']['name']).to eq('Linux')
  end

  it 'uses the overridden attributes' do
    expect(my_node['foo']['bar']).to eq('zip')
  end
end
