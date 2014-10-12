require 'spec_helper'

describe ChefSpec::Runner, :ignored => true do
  before(:all) do
    require 'chefspec/server'
  end

  describe '#initialize' do
    subject {} # need to explicitly control the creation

    context 'solo is global rspec default' do
      before do
        allow(RSpec.configuration).to receive(:mode).and_return(:solo)
      end

      it 'it defaults to a solo runner' do
        runner = described_class.new
        expect(Chef::Config[:solo]).to eq(true)
        expect(Chef::Config[:client_key]).to be_nil
        expect(runner.options[:mode]).to eq(:solo)
      end

      it 'it creates a server runner explicitely' do
        runner = described_class.new(mode: :server, cookbook_path: [File.expand_path(File.dirname(__FILE__))])
        expect(Chef::Config[:solo]).to eq(false)
        expect(Chef::Config[:client_key]).to eq(ChefSpec::Server.client_key)
        expect(runner.options[:mode]).to eq(:server)
      end
    end

    context 'server is global rspec default' do
      before do
        allow(RSpec.configuration).to receive(:mode).and_return(:server)
      end

      it 'defaults to a server runner' do
        runner = described_class.new(cookbook_path: [File.expand_path(File.dirname(__FILE__))])
        expect(Chef::Config[:solo]).to eq(false)
        expect(Chef::Config[:client_key]).to eq(ChefSpec::Server.client_key)
        expect(runner.options[:mode]).to eq(:server)
      end

      it 'creates a solo runner explicitely' do
        runner = described_class.new(mode: :solo)
        expect(Chef::Config[:solo]).to eq(true)
        expect(Chef::Config[:client_key]).to be_nil
        expect(runner.options[:mode]).to eq(:solo)
      end
    end

  end
end
