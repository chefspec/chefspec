require 'spec_helper'

# coverage report output tests
describe ChefSpec::Coverage::PutsOutput do
  subject { described_class.new }

  describe 'outputs to std out' do
    it 'outputs to std out when output' do
      expect{ subject.output('hello there')}.to output("hello there\n").to_stdout
    end

  end
end

describe ChefSpec::Coverage::BlockOutput do

  allOutput = []
  subject = described_class.new {|x| allOutput << x }

  it 'outputs using block' do
    subject.output('hello again')
    expect(allOutput).to contain_exactly('hello again')
  end
end