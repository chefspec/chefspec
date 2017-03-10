require 'spec_helper'

describe ChefSpec::SoloRunner do
  before do
    allow_any_instance_of(ChefSpec::SoloRunner)
      .to receive(:dry_run?)
      .and_return(true)
  end

  describe '#initialize' do
    let(:windows_caller_stack) do
      [
        "C:/cookbooks/Temp/spec/test_spec.rb:11:in `block (2 levels) in <top (required)>'",
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
        "C:/Ruby193/lib/ruby/gems/1.9.1/gems/rspec-core-2.14.8/lib/rspec/core/runner.rb:17:in `block in autorun'",
      ]
    end

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

    it 'sets the file cache path' do
      described_class.new( file_cache_path: '/tmp/pantoa')
      expect(Chef::Config.file_cache_path).to eq('/tmp/pantoa')
    end

    it 'sets the Chef::Config' do
      expect(Chef::Config.cache_type).to eq('Memory')
      expect(Chef::Config.force_logger).to be_truthy
      expect(Chef::Config.no_lazy_load).to be_truthy
      expect(Chef::Config.solo).to be_truthy
      expect(Chef::Config.use_policyfile).to be_falsey
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
      let(:hash) { described_class.new(platform: 'ubuntu', version: '16.04').node.to_hash }

      it 'sets the attributes from fauxhai' do
        expect(hash['os']).to eq('linux')
        expect(hash['languages']['ruby']['ruby_bin']).to eq('/usr/local/bin/ruby')
        expect(hash['os_version']).to match(/4.4.0-.*-generic/) # avoid failing when fauxhai data changes
        expect(hash['fqdn']).to eq('fauxhai.local')
        expect(hash['domain']).to eq('local')
        expect(hash['ipaddress']).to eq('10.0.0.2')
        expect(hash['hostname']).to eq('Fauxhai')
        expect(hash['kernel']['machine']).to eq('x86_64')
      end
    end

    context 'RSpec global configuration' do
      before do
        allow(RSpec.configuration).to receive(:cookbook_path).and_return('./path')
        allow(RSpec.configuration).to receive(:environment_path).and_return('./env-path')
        allow(RSpec.configuration).to receive(:file_cache_path).and_return('./file-cache-path')
        allow(RSpec.configuration).to receive(:log_level).and_return(:fatal)
        allow(RSpec.configuration).to receive(:path).and_return('ohai.json')
        allow(RSpec.configuration).to receive(:platform).and_return('ubuntu')
        allow(RSpec.configuration).to receive(:version).and_return('12.04')
      end

      it 'uses the RSpec values' do
        options = described_class.new.options
        expect(options[:cookbook_path]).to eq('./path')
        expect(options[:environment_path]).to eq('./env-path')
        expect(options[:file_cache_path]).to eq('./file-cache-path')
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
      subject.node.normal['bacon'] = 'ham'
      expect(subject.node.bacon).to eq('ham')
    end
  end

  describe '#to_s' do
    it 'overrides the default string representation to something readable' do
      expect(subject.converge('apache2::default').to_s)
        .to eq('#<ChefSpec::SoloRunner run_list: [recipe[apache2::default]]>')
    end

    it 'is ok when a convergence has not yet taken place' do
      expect(subject.to_s).to eq('#<ChefSpec::SoloRunner run_list: []>')
    end

    it 'includes the entire run_list' do
      expect(subject.converge('apache2::default', 'apache2::mod_ssl').to_s)
        .to eq('#<ChefSpec::SoloRunner run_list: [recipe[apache2::default], recipe[apache2::mod_ssl]]>')
    end

    it 'has the run_list only for the last convergence' do
      ['mysql::client', 'mysql::server'].each { |recipe| subject.converge(recipe) }
      expect(subject.to_s)
        .to eq('#<ChefSpec::SoloRunner run_list: [recipe[mysql::server]]>')
    end
  end
end
