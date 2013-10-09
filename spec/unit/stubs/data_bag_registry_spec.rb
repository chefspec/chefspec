require 'spec_helper'

describe ChefSpec::Stubs::DataBagRegistry do
  before { described_class.reset! }

  it 'inherits from Registry' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Registry)
  end

  describe '#stub_for' do
    it 'finds a stub by name' do
      search = double('search', bag: 'users')
      described_class.register(search)
      expect(described_class.stub_for('users')).to eq(search)
    end

    it 'finds a stub by Regex' do
      search = double('search', bag: 'users')
      described_class.register(search)
      expect(described_class.stub_for('users')).to eq(search)
    end

    it 'matches when the bag is Symbol' do
      search = double('search', bag: :users)
      described_class.register(search)
      expect(described_class.stub_for('users')).to eq(search)
    end

    it 'matches when the stub is Symbol' do
      search = double('search', bag: 'users')
      described_class.register(search)
      expect(described_class.stub_for(:users)).to eq(search)
    end

    it 'returns nil when no searches are matched' do
      expect(described_class.stub_for('users')).to eq(nil)
    end
  end
end
