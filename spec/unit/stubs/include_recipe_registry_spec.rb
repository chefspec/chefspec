require 'spec_helper'

describe ChefSpec::Stubs::IncludeRecipeRegistry do
  before { described_class.reset! }

  it 'inherits from Registry' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Registry)
  end

  describe '#stub_for' do
    it 'finds a stub by name' do
      search = double('search', recipe: 'cookbook::recipe')
      described_class.register(search)
      expect(described_class.stub_for('cookbook::recipe')).to eq(search)
    end

    it 'returns nil when no searches are matched' do
      expect(described_class.stub_for('other_cookbook::recipe')).to eq(nil)
    end
  end
end
