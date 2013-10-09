require 'spec_helper'

describe ChefSpec::Stubs::Stub do
  describe '#and_return' do
    subject { described_class.new.and_return('value') }

    it 'sets the value' do
      expect(subject.value).to eq('value')
    end

    it 'returns an instance of the stub' do
      expect(subject.and_return('value')).to be(subject)
    end
  end

  describe '#and_raise' do
    subject { described_class.new.and_raise(ArgumentError) }

    it 'sets the block' do
      expect(subject.instance_variable_get(:@block)).to be_a(Proc)
    end

    it 'returns an instance of the stub' do
      expect(subject.and_raise(ArgumentError)).to be(subject)
    end
  end

  describe '#result' do
    context 'when a value is given' do
      subject { described_class.new.and_return('value') }

      it 'returns the value' do
        expect(subject.result).to eq('value')
      end
    end

    context 'when a block is given' do
      subject { described_class.new }

      it 'calls the block' do
        subject.instance_variable_set(:@block, Proc.new { 1 == 2 })
        expect(subject.result).to eq(false)
      end
    end

    context 'when an exception block is given' do
      subject { described_class.new.and_raise(ArgumentError) }

      it 'raises the exception' do
        expect {
          subject.result
        }.to raise_error(ArgumentError)
      end
    end

    context 'when the value is a Hash' do
      subject { described_class.new.and_return([ { name: 'a' } ]) }

      it 'recursively mashifies the value' do
        expect(subject.result.first).to be_a(Mash)
      end
    end
  end
end
