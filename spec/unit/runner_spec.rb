require 'spec_helper'

describe ChefSpec::Runner do
  before do
    ChefSpec::Runner.any_instance.stub(:dry_run?).and_return(true)
  end

  describe '#initialize' do
    subject {} # need to explicitly control the creation
    let(:windows_caller_stack) {
      ["C:/cookbooks/Temp/spec/test_spec.rb:11:in `block (2 levels) in <top (required)>'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example.rb:114:in `instance_eval'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example.rb:114:in `block in run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example.rb:254:in `with_around_each_hooks'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example.rb:111:in `run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example_group.rb:390:in `block in run_examples'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example_group.rb:386:in `map'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example_group.rb:386:in `run_examples'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/example_group.rb:371:in `run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/command_line.rb:28:in `block (2 levels) in run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/command_line.rb:28:in `map'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/command_line.rb:28:in `block in run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/reporter.rb:58:in `report'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/command_line.rb:25:in `run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/runner.rb:80:in `run'",
       "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/runner.rb:17:in `block in autorun'"]
    }

    it 'defaults the log level to :warn' do
      described_class.new
      expect(Chef::Log.level).to eq(:warn)
    end

    it 'sets the log level' do
      described_class.new(log_level: :error)
      expect(Chef::Log.level).to eq(:error)
    end

    it 'defaults the cookbook_path to the calling spec' do
      described_class.new
      expect(Chef::Config.cookbook_path).to eq([File.expand_path('../../../..', __FILE__)])
    end

    it 'defaults the cookbook_path to the calling spec when using windows paths' do
      runner = described_class.new
      windows_path = runner.instance_exec(windows_caller_stack) { |callstack|
        calling_cookbook_path(callstack)
      }
      # There's got to be a better way to do this the File.expand_path returns
      # something like /home/user/repos/chefspec/C:/cookbooks" which is less
      # than ideal as a robust test
      expect(windows_path).to end_with("C:/cookbooks")
    end

    it 'sets the cookbook path' do
      described_class.new(cookbook_path: '/tmp/bacon')
      expect(Chef::Config.cookbook_path).to eq(['/tmp/bacon'])
    end

    it 'sets the Chef::Config' do
      expect(Chef::Config.cache_type).to eq('Memory')
      expect(Chef::Config.force_logger).to be_true
      expect(Chef::Config.no_lazy_load).to be_true
      expect(Chef::Config.solo).to be_true
    end

    it 'yields a block to set node attributes' do
      expect { |block| described_class.new({}, &block) }.to yield_with_args(Chef::Node)
    end

    context 'default ohai attributes' do
      let(:hash) { described_class.new.node.to_hash }

      it 'sets the default attributes' do
        expect(hash['os']).to eq('chefspec')
        expect(hash['languages']['ruby']['bin_dir']).to eq('/usr/local/bin')
        expect(hash['os_version']).to eq('0.6.1')
        expect(hash['fqdn']).to eq('chefspec.local')
        expect(hash['domain']).to eq('local')
        expect(hash['ipaddress']).to eq('127.0.0.1')
        expect(hash['hostname']).to eq('chefspec')
        expect(hash['kernel']['machine']).to eq('i386')
      end
    end

    context 'fauxhai attributes' do
      let(:hash) { described_class.new(platform: 'ubuntu', version: '12.04').node.to_hash }

      it 'sets the attributes from fauxhai' do
        expect(hash['os']).to eq('linux')
        expect(hash['languages']['ruby']['ruby_bin']).to eq('/usr/local/bin/ruby')
        expect(hash['os_version']).to eq('3.2.0-26-generic')
        expect(hash['fqdn']).to eq('fauxhai.local')
        expect(hash['domain']).to eq('local')
        expect(hash['ipaddress']).to eq('10.0.0.2')
        expect(hash['hostname']).to eq('Fauxhai')
        expect(hash['kernel']['machine']).to eq('x86_64')
      end
    end

    context 'RSpec global configuration' do
      before do
        RSpec.configuration.stub(:cookbook_path).and_return('./path')
        RSpec.configuration.stub(:log_level).and_return(:fatal)
        RSpec.configuration.stub(:path).and_return('ohai.json')
        RSpec.configuration.stub(:platform).and_return('ubuntu')
        RSpec.configuration.stub(:version).and_return('12.04')
      end

      it 'uses the RSpec values' do
        options = described_class.new.options
        expect(options[:cookbook_path]).to eq('./path')
        expect(options[:log_level]).to eq(:fatal)
        expect(options[:path]).to eq('ohai.json')
        expect(options[:platform]).to eq('ubuntu')
        expect(options[:version]).to eq('12.04')
      end
    end
  end

  describe '#node' do
    it 'returns the Chef::Node' do
      expect(subject.node).to be_a(Chef::Node)
    end

    it 'defines a #runner method that returns self' do
      expect(subject.node.methods).to include(:runner)
      expect(subject.node.runner).to be(subject)
    end

    it 'allows attributes to be set on the node' do
      subject.node.set['bacon'] = 'ham'
      expect(subject.node.bacon).to eq('ham')
    end
  end

  describe '#node=' do
    it 'raises an exception if a non-node object is passed' do
      expect { subject.node = nil }.to raise_error
    end
    
    it 'properly associates runner to node' do
      subject.node = Chef::Node.new
      expect(subject.node.methods).to include(:runner)
      expect(subject.node.runner).to be(subject)
    end

    it 'properly associates node to runner' do
      node = Chef::Node.new
      subject.node = node
      expect(node.runner).to be(subject)
    end
  end

  describe '#to_s' do
    it 'overrides the default string representation to something readable' do
      expect(subject.converge('apache2::default').to_s).to eq('chef_run: recipe[apache2::default]')
    end

    it 'is ok when a convergence has not yet taken place' do
      expect(subject.to_s).to eq('chef_run')
    end

    it 'includes the entire run_list' do
      expect(subject.converge('apache2::default', 'apache2::mod_ssl').to_s).to eq('chef_run: recipe[apache2::default], recipe[apache2::mod_ssl]')
    end

    it 'has the run_list only for the last convergence' do
      ['mysql::client', 'mysql::server'].each { |recipe| subject.converge(recipe) }
      expect(subject.to_s).to eq('chef_run: recipe[mysql::server]')
    end
  end
end
