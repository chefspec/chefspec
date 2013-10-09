require 'spec_helper'

describe ChefSpec::Stubs::DataBagStub do
  it 'inherts from Stub' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Stub)
  end

  describe '#initialize' do
    it 'sets the bag and block' do
      block = Proc.new {}
      stub  = described_class.new('bag', &block)

      expect(stub.bag).to eq('bag')
      expect(stub.block).to eq(block)
    end
  end

  describe '#signature' do
    context 'when a value is given' do
      subject { described_class.new('bag').and_return(false) }

      it 'includes the value' do
        expect(subject.signature).to eq('stub_data_bag("bag").and_return(false)')
      end
    end

    context 'when a block is given' do
      subject { described_class.new('bag') { 1 == 2 } }

      it 'includes a comment about the block' do
        expect(subject.signature).to eq('stub_data_bag("bag") { # Ruby code }')
      end
    end
  end
end
