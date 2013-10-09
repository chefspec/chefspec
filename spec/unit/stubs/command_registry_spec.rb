require 'spec_helper'

describe ChefSpec::Stubs::CommandRegistry do
  before { described_class.reset! }

  it 'inherits from Registry' do
    expect(described_class.superclass).to be(ChefSpec::Stubs::Registry)
  end

  describe '#stub_for' do
    it 'finds a stub by name' do
      command = double('command', command: 'test -f /var/www')
      described_class.register(command)
      expect(described_class.stub_for('test -f /var/www')).to eq(command)
    end

    it 'finds a stub by regex' do
      command = double('command', command: /test -f (.+)/)
      described_class.register(command)
      expect(described_class.stub_for('test -f /var/www')).to eq(command)
    end

    it 'returns nil when no commands are matched' do
      expect(described_class.stub_for('which a2ensite')).to eq(nil)
    end
  end
end
