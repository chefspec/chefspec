require 'spec_helper'

describe ChefSpec::Runner do
  before do
    ChefSpec::Runner.any_instance.stub(:dry_run?).and_return(true)
  end

  describe '#initialize' do
    subject {} # need to explicitly control the creation

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

    it 'sets the cookbook path' do
      described_class.new(cookbook_path: '/tmp/bacon')
      expect(Chef::Config.cookbook_path).to eq(['/tmp/bacon'])
    end

    it 'sets the Chef::Config' do
      expect(Chef::Config.cache_type).to eq('Memory')
      expect(Chef::Config.force_logger).to be_true
      expect(Chef::Config.solo).to be_true
    end

    it 'yields a block to set node attributes' do
      expect { |block| described_class.new({}, &block) }.to yield_with_args(Chef::Node)
    end

    context 'default ohai attributes' do
      let(:hash) { described_class.new.node.to_hash }

      it 'sets the default attributes' do
        expect(hash['os']).to eq('chefspec')
        expect(hash['languages']['ruby']).to eq('/usr/somewhere')
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
