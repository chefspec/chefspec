require "spec_helper"

describe ChefSpec::FileCachePathProxy do
  subject { described_class.instance }

  it "is a singleton" do
    expect(described_class.instance).to be(described_class.instance)
  end

  it "exposes a real, existing temp directory" do
    expect(subject.file_cache_path).to be_a(String)
    expect(Dir.exist?(subject.file_cache_path)).to be(true)
  end
end
