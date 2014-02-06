require 'spec_helper'

describe ChefSpec::ExpectException do
  context 'when there have been no `raise_error` matchers' do
    subject { described_class.new(Exception) }

    it 'does not match' do
      RSpec::Matchers::BuiltIn::RaiseError.stub(:last_run).and_return(nil)
      expect(subject.expected?).to be_false
    end
  end

  context 'when the last error does not match the expected type' do
    subject { described_class.new(RuntimeError) }

    it 'does not match' do
      last_error = double('last error', last_error_for_chefspec: ArgumentError)
      RSpec::Matchers::BuiltIn::RaiseError.stub(:last_run).and_return(last_error)
      expect(subject.expected?).to be_false
    end
  end

  context 'when the last error matches the expected type' do
    subject { described_class.new(RuntimeError) }

    it 'does not match' do
      last_error = double('last error', last_error_for_chefspec: RuntimeError)
      RSpec::Matchers::BuiltIn::RaiseError.stub(:last_run).and_return(last_error)
      expect(subject.expected?).to be_true
    end
  end
end
