require 'spec_helper'

describe 'nginx::source' do
  it 'sets described_recipe to nginx::source' do
    expect(described_recipe).to eq('nginx::source')
  end

  it 'sets described_cookbook to nginx' do
    expect(described_cookbook).to eq('nginx')
  end

  context 'in a nested context' do
    it 'still sets described_recipe to nginx::source' do
      expect(described_recipe).to eq('nginx::source')
    end

    it 'still sets described_cookbook to nginx' do
      expect(described_cookbook).to eq('nginx')
    end
  end
end
