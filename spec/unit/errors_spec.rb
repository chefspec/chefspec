require 'spec_helper'

module ChefSpec::Error
  describe CommandNotStubbed do
    let(:instance) { described_class.new(args: ['cat']) }

    it 'raises an exception with the correct message' do
      instance
      expect { raise instance }.to raise_error { |error|
        expect(error).to be_a(described_class)
        expect(error.message).to eq <<-EOH.gsub(/^ {10}/, '')
          Executing a real command is disabled. Unregistered command:

              command("cat")

          You can stub this command with:

              stub_command("cat").and_return(...)
        EOH
      }
    end
  end

  describe CookbookPathNotFound do
    let(:instance) { described_class.new }

    it 'raises an exception with the correct message' do
      expect { raise instance }.to raise_error { |error|
        expect(error).to be_a(described_class)
        expect(error.message).to eq <<-EOH.gsub(/^ {10}/, '')
          I could not find or infer a cookbook_path from your current working directory.
          Please make sure you put your specs (tests) under a directory named 'spec' or
          manually set the cookbook path in the RSpec configuration.
        EOH
      }
    end
  end

  describe GemLoadError do
    let(:instance) { described_class.new(gem: 'bacon', name: 'bacon') }

    it 'raises an exception with the correct message' do
      expect { raise instance }.to raise_error { |error|
        expect(error).to be_a(described_class)
        expect(error.message).to eq <<-EOH.gsub(/^ {10}/, '')
          I could not load the 'bacon' gem! You must have the gem installed
          on your local system before you can use the bacon plugin.
          You can install bacon by running:

              gem install bacon

          or add bacon to your Gemfile and run the `bundle` command to install.
        EOH
      }
    end
  end
end
