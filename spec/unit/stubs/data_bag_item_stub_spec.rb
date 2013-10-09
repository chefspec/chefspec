require 'spec_helper'

describe ChefSpec::Stubs::DataBagItemStub do
  it 'inherts from Stub' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Stub)
  end

  describe '#initialize' do
    it 'sets the bag, id, and block' do
      block = Proc.new {}
      stub  = described_class.new('bag', 'id', &block)

      expect(stub.bag).to eq('bag')
      expect(stub.id).to eq('id')
      expect(stub.block).to eq(block)
    end
  end

  describe '#signature' do
    context 'when a value is given' do
      subject { described_class.new('bag', 'id').and_return(false) }

      it 'includes the value' do
        expect(subject.signature).to eq('stub_data_bag_item("bag", "id").and_return(false)')
      end
    end

    context 'when a block is given' do
      subject { described_class.new('bag', 'id') { 1 == 2 } }

      it 'includes a comment about the block' do
        expect(subject.signature).to eq('stub_data_bag_item("bag", "id") { # Ruby code }')
      end
    end
  end
end
