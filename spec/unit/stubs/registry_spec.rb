require 'spec_helper'

describe ChefSpec::Stubs::Registry do
  before { described_class.reset! }

  describe '#reset!' do
    it 'cleans the list of stubs' do
      described_class.stubs = [1, 2, 3]
      described_class.reset!

      expect(described_class.stubs).to be_empty
    end
  end

  describe '#register' do
    it 'adds the stub to the registry' do
      described_class.register('bacon')
      expect(described_class.stubs).to include('bacon')
    end
  end

  describe '#stub_for' do
    it 'finds a stub by name' do
      expect {
        described_class.stub_for
      }.to raise_error(ArgumentError)
    end
  end
end
