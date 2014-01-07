require 'chefspec'

describe 'stub_command::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'when the command is not stubbed' do
    it 'raises an exception' do
      expect {
        chef_run
      }.to raise_error(ChefSpec::Error::CommandNotStubbed)
    end
  end

  context 'as a String' do
    it 'does not raise an exception' do
      stub_command('test -f "/tmp/file"').and_return(true)
      stub_command('test -f "/tmp/other_file"').and_return(true)
      expect { chef_run }.to_not raise_error
    end
  end

  context 'as a Regexp' do
    it 'does not raise an exception' do
      stub_command(/test -f "(.+)"/) { 1 == 2 }
      expect { chef_run }.to_not raise_error
    end
  end
end
