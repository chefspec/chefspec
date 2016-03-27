require 'spec_helper'

describe ChefSpec::ServerRunner do
  context 'when the RSpec config is set' do
    it 'does not create a tmpdir' do
      allow(RSpec.configuration).to receive(:file_cache_path)
        .and_return("/foo/bar")
      expect(ChefSpec::FileCachePathProxy).to_not receive(:instance)
      described_class.new
    end
  end

  context 'when the RSpec config is not set' do
    it 'creates and returns a tmpdir' do
      expect(ChefSpec::FileCachePathProxy).to receive(:instance)
        .and_call_original
      described_class.new
      expect(Chef::Config[:file_cache_path]).to match(/chefspec/)
    end

    it 'uses the same path' do
      val = ChefSpec::FileCachePathProxy.instance.file_cache_path
      expect(described_class.new.options[:file_cache_path]).to eq(val)
      expect(described_class.new.options[:file_cache_path]).to eq(val)
      expect(described_class.new.options[:file_cache_path]).to eq(val)
    end
  end
end
