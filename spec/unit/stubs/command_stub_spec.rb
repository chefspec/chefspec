require 'spec_helper'

describe ChefSpec::Stubs::CommandStub do
  describe '#initialize' do
    it 'sets the command and block' do
      block = Proc.new {}
      stub  = described_class.new('command', &block)

      expect(stub.command).to eq('command')
      expect(stub.block).to eq(block)
    end
  end

  describe '#and_return' do
    subject { described_class.new('command').and_return('value') }

    it 'sets the value' do
      expect(subject.value).to eq('value')
    end

    it 'returns an instance of the stub' do
      expect(subject.and_return('value')).to be(subject)
    end
  end

  describe '#result' do
    context 'when a value is given' do
      subject { described_class.new('command').and_return('value') }

      it 'returns the value' do
        expect(subject.result).to eq('value')
      end
    end

    context 'when a block is given' do
      subject { described_class.new('command') { 1 == 2 } }

      it 'calls the block' do
        expect(subject.result).to eq(false)
      end
    end
  end

  describe '#signature' do
    context 'when a value is given' do
      subject { described_class.new('command').and_return(false) }

      it 'includes the value' do
        expect(subject.signature).to eq('stub_command("command").and_return(false)')
      end
    end

    context 'when a block is given' do
      subject { described_class.new('command') { 1 == 2 } }

      it 'includes a comment about the block' do
        expect(subject.signature).to eq('stub_command("command") { # Ruby code }')
      end
    end
  end
end
