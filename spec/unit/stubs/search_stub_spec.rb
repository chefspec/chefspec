require 'spec_helper'

describe ChefSpec::Stubs::SearchStub do
  it 'inherts from Stub' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Stub)
  end

  describe '#initialize' do
    it 'sets the type, query, and block' do
      block = Proc.new {}
      stub  = described_class.new('type', 'query', &block)

      expect(stub.type).to eq('type')
      expect(stub.query).to eq('query')
      expect(stub.block).to eq(block)
    end
  end

  describe '#signature' do
    context 'when a value is given' do
      subject { described_class.new('type', 'query').and_return(false) }

      it 'includes the value' do
        expect(subject.signature).to eq('stub_search("type", "query").and_return(false)')
      end
    end

    context 'when a block is given' do
      subject { described_class.new('type', 'query') { 1 == 2 } }

      it 'includes a comment about the block' do
        expect(subject.signature).to eq('stub_search("type", "query") { # Ruby code }')
      end
    end
  end
end
