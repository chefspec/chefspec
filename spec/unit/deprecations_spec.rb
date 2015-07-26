require 'spec_helper'

describe ChefSpec::Runner do
  before do
    allow_any_instance_of(ChefSpec::SoloRunner)
      .to receive(:dry_run?)
      .and_return(true)
    allow(ChefSpec::Runner).to receive(:deprecated)
  end

  describe '#define_runner_method' do
    before do
      allow(ChefSpec).to receive(:define_matcher)
    end

    it 'prints a deprecation' do
      expect(ChefSpec::Runner).to receive(:deprecated)
        .with("`ChefSpec::Runner.define_runner_method' is deprecated."\
          " It is being used in the my_custom_resource resource matcher." \
          " Please use `ChefSpec.define_matcher' instead.")
      ChefSpec::Runner.define_runner_method(:my_custom_resource)
    end

    it 'calls ChefSpec#define_matcher' do
      expect(ChefSpec).to receive(:define_matcher).with(:my_custom_resource).once
      ChefSpec::Runner.define_runner_method(:my_custom_resource)
    end

  end

  describe '#new' do
    before do
      allow(ChefSpec::SoloRunner).to receive(:new)
    end

    it 'prints a deprecation' do
      expect(ChefSpec::Runner).to receive(:deprecated)
        .with("`ChefSpec::Runner' is deprecated. Please use" \
        " `ChefSpec::SoloRunner' or `ChefSpec::ServerRunner' instead.")
      ChefSpec::Runner.new
    end

    it 'calls SoloRunner#new with no args' do
      expect(ChefSpec::SoloRunner).to receive(:new).with(no_args()).once
      ChefSpec::Runner.new
    end

    it 'calls SoloRunner#new with args' do
      args = [ 'args' ]
      expect(ChefSpec::SoloRunner).to receive(:new).with(*args).once
      ChefSpec::Runner.new(*args)
    end

  end
end

describe ChefSpec::Server do
  before do
    allow(ChefSpec::Server).to receive(:deprecated)
  end

  it 'prints a deprecation for any method called' do
    expect(ChefSpec::Server).to receive(:deprecated)
      .with("`ChefSpec::Server.any_method' is deprecated. There is no longer" \
        " a global Chef Server instance. Please use a ChefSpec::ServerRunner" \
        " instead. More documentation can be found in the ChefSpec README."
      )
    expect {
      ChefSpec::Server.any_method
    }.to raise_error(ChefSpec::Error::NoConversionError)
  end

  it 'raises non-conversion error for any method called' do
    expect{ChefSpec::Server.any_method}
      .to raise_error(ChefSpec::Error::NoConversionError)
  end

end
