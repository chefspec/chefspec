require 'spec_helper'

describe ChefSpec::Stubs::IncludeRecipeStub do
  it 'inherts from Stub' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Stub)
  end

  describe '#initialize' do
    it 'sets the recipe' do
      stub = described_class.new('cookbook::recipe')
      expect(stub.recipe).to eq('cookbook::recipe')
    end
  end

  describe '#signature' do
    subject { described_class.new('cookbook::recipe') }

    it 'includes the value' do
      expect(subject.signature).to eq('stub_include_recipe("cookbook::recipe")')
    end
  end
end
