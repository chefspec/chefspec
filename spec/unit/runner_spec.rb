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

# describe ChefSpec::Runner do
#   describe '#initialize' do
#     it 'aliases the real resource actions' do
#       described_class.new
#       expect(Chef::Resource::File).to be_method_defined(:old_run_action)
#     end

#     it 'captures the resources created' do
#       runner = described_class.new
#       file = Chef::Resource::File.new('/tmp/foo.txt')
#       file.run_action(:create)
#       expect(runner.resources.size).to eq 1
#       expect(runner.resources.first).to equal(file)
#     end

#     it 'executes the real action if resource is in the step_into list' do
#       runner = described_class.new(step_into: ['file'])
#       file = Chef::Resource::File.new('/tmp/foo.txt')
#       file.should_receive(:old_run_action).with(:create)
#       file.run_action(:create)
#     end

#     context 'stepping into lwrps' do
#       before do
#         Chef::Platform.stub(:provider_for_resource) { double.as_null_object }
#       end

#       let(:not_if_action) { double }
#       let(:only_if_action) { double }
#       let(:file) do
#         file = Chef::Resource::File.new('/tmp/foo.txt')
#         file.not_if { not_if_action.call }
#         file.only_if { only_if_action.call }
#         file
#       end

#       it 'does not execute not_if/only_if guards' do
#         runner = described_class.new(step_into: ['file'])
#         not_if_action.should_receive(:call).never
#         only_if_action.should_receive(:call).never
#         file.stub(:run_context) { double.as_null_object }
#         file.run_action(:create)
#       end

#       it 'executes not_if/only_if guards if asked to' do
#         described_class.new(step_into: ['file'], evaluate_guards: true)
#         not_if_action.should_receive(:call).once.and_return(false)
#         only_if_action.should_receive(:call).once.and_return(true)
#         file.stub(:run_context){ double.as_null_object }
#         file.run_action(:create)
#       end
#     end

#     it 'allows evaluate_guards to be falsey' do
#       expect(
#         described_class.new({ evaluate_guards: false}).evaluate_guards?
#       ).to be_false
#     end

#     it 'allows evaluate_guards to be truthy' do
#       expect(
#         described_class.new({ evaluate_guards: true }).evaluate_guards?
#       ).to be_true
#     end
#   end

#   describe '#stub_command' do
#     let(:chef_run) { described_class.new }

#     it 'allows a stub to be defined as a string' do
#       chef_run.stub_command('which blah', true)
#       expect(chef_run.stubbed_commands['which blah']).to be_true
#     end

#     it 'allows a stub to be defined as a regex' do
#       chef_run.stub_command(/which/, false)
#       expect(chef_run.stubbed_commands[/which/]).to be_false
#     end

#     it 'allows multiple commands to be stubbed' do
#       chef_run.stub_command(/which/, true)
#       chef_run.stub_command(/grep/, false)
#       expect(chef_run.stubbed_commands[/which/]).to be_true
#       expect(chef_run.stubbed_commands[/grep/]).to be_false
#     end
#   end

#   describe '#converge' do
#     let(:chef_run) { described_class.new }

#     it 'rethrows the exception if a cookbook cannot be found' do
#       expect {
#         chef_run.converge('non_existent::default')
#       }.to raise_error(Chef::Exceptions::CookbookNotFound)
#     end

#     it 'returns a reference to the runner' do
#       expect(chef_run.converge).to be_a(described_class)
#     end
#     it "should not execute guards by default" do
#       Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
#       runner = described_class.new
#       not_if_action = double()
#       only_if_action = double()
#       file = Chef::Resource::File.new '/tmp/foo.txt'
#       file.not_if{ not_if_action.call }
#       file.only_if{ only_if_action.call }
#       not_if_action.should_receive(:call).never
#       only_if_action.should_receive(:call).never
#       file.stub(:run_context){ double.as_null_object }
#       file.run_action(:create)
#     end
#     it "should not execute ruby guards if explicitly asked not to" do
#       Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
#       runner = described_class.new({:evaluate_guards => false})
#       not_if_action = double()
#       only_if_action = double()
#       file = Chef::Resource::File.new '/tmp/foo.txt'
#       file.not_if{ not_if_action.call }
#       file.only_if{ only_if_action.call }
#       not_if_action.should_receive(:call).never
#       only_if_action.should_receive(:call).never
#       file.stub(:run_context){ double.as_null_object }
#       file.run_action(:create)
#     end
#     it "should execute ruby guards if asked to" do
#       Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
#       runner = described_class.new({:evaluate_guards => true})
#       not_if_action = double()
#       only_if_action = double()
#       file = Chef::Resource::File.new '/tmp/foo.txt'
#       file.not_if{ not_if_action.call }
#       file.only_if{ only_if_action.call }
#       not_if_action.should_receive(:call).once.and_return(false)
#       only_if_action.should_receive(:call).once.and_return(true)
#       file.stub(:run_context){ double.as_null_object }
#       file.run_action(:create)
#     end
#     context "executing shell guards" do
#       before :each do
#         Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
#         described_class.new({:evaluate_guards => true})
#       end
#       let(:file) do
#         file = Chef::Resource::File.new '/tmp/foo.txt'
#         file.stub(:run_context){ double.as_null_object }
#         file
#       end
#       it "raises if a not_if shell guard has not been stubbed" do
#         file.not_if "non-existent-command"
#         expect{ file.run_action(:create)}.to raise_error(
#           RSpec::Mocks::MockExpectationError,
#           'The following shell guard was unstubbed: not_if command `non-existent-command`')
#       end
#       it "raises if an only_if shell guard has not been stubbed" do
#         file.only_if "ls"
#         expect{ file.run_action(:create)}.to raise_error(
#           RSpec::Mocks::MockExpectationError,
#           'The following shell guard was unstubbed: only_if command `ls`')
#       end
#       it "raises if a stub is provided that doesn't match" do
#         file.only_if "ls"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command('dir', false)
#         expect{ file.run_action(:create)}.to raise_error(
#           RSpec::Mocks::MockExpectationError,
#           'The following shell guard was unstubbed: only_if command `ls`')
#       end
#       context "actually evaluating shell guards" do
#         it "doesn't actually run shell guards" do
#           file.only_if "non-existent-command"
#           chef_run = described_class.new({:evaluate_guards => true})
#           Chef::Resource::Conditional.any_instance.should_not_receive(
#             :original_evaluate_command)
#           expect{ file.run_action(:create)}.to raise_error(
#             RSpec::Mocks::MockExpectationError,
#             'The following shell guard was unstubbed: only_if command `non-existent-command`')
#         end
#         it "uses stubs in preference to the actual command if defined" do
#           file.only_if "ls"
#           Chef::Resource::Conditional.any_instance.should_not_receive(
#             :original_evaluate_command)
#           chef_run = described_class.new(
#             {:evaluate_guards => true, :actually_run_shell_guards => true})
#           chef_run.stub_command('ls', true)
#           file.run_action(:create)
#           expect(chef_run).to create_file '/tmp/foo.txt'
#         end
#         it "runs shell guards that are not stubbed if explicitly asked to" do
#           file.only_if "non-existent-command"
#           chef_run = described_class.new(
#             {:evaluate_guards => true, :actually_run_shell_guards => true})
#           Chef::Resource::Conditional.any_instance.should_receive(
#             :original_evaluate_command).and_return(true)
#           file.run_action(:create)
#           expect(chef_run).to create_file '/tmp/foo.txt'
#         end
#       end
#       it "omits the resource if the guard is failed" do
#         file.only_if "which foo"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command('which foo', false)
#         file.run_action(:create)
#         expect(chef_run).to_not create_file '/tmp/foo.txt'
#       end
#       it "includes the resource if the guard is passed (string stub)" do
#         file.only_if "which foo"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command('which foo', true)
#         file.run_action(:create)
#         expect(chef_run).to create_file '/tmp/foo.txt'
#       end
#       it "includes the resource if the guard is passed (regex stub)" do
#         file.only_if "which foo"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command(/which/, true)
#         file.run_action(:create)
#         expect(chef_run).to create_file '/tmp/foo.txt'
#       end
#       it "stubs multiple conditionals from multiple stubs" do
#         file.only_if "which foo"
#         file.only_if "which baz"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command(/foo/, true)
#         chef_run.stub_command(/baz/, true)
#         file.run_action(:create)
#         expect(chef_run).to create_file '/tmp/foo.txt'
#       end
#       it "stubs multiple conditionals from a single stub if they match" do
#         file.only_if "which foo"
#         file.only_if "which baz"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command(/which/, true)
#         file.run_action(:create)
#         expect(chef_run).to create_file '/tmp/foo.txt'
#       end
#       it "applies stubs in the order in which they are stubbed" do
#         file.only_if "which azimuth"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command(/zi/, true)
#         chef_run.stub_command(/a/, false)
#         file.run_action(:create)
#         expect(chef_run).to create_file '/tmp/foo.txt'
#       end
#       it "allows stub results to be replaced if the commands are identical" do
#         file.only_if "which azimuth"
#         chef_run = described_class.new({:evaluate_guards => true})
#         chef_run.stub_command(/a/, true)
#         chef_run.stub_command(/a/, false)
#         file.run_action(:create)
#         expect(chef_run).not_to create_file '/tmp/foo.txt'
#       end
#     end
#     it "omits the resource if the guard is failed" do
#       Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
#       runner = described_class.new({:evaluate_guards => true})
#       not_if_action = double()
#       only_if_action = double()
#       file = Chef::Resource::File.new '/tmp/foo.txt'
#       file.only_if{ only_if_action.call }
#       only_if_action.should_receive(:call).once.and_return(false)
#       file.stub(:run_context){ double.as_null_object }
#       file.run_action(:create)
#       expect(runner).to_not create_file '/tmp/foo.txt'
#     end
#     it "includes the resource if the guard is passed" do
#       Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
#       runner = described_class.new({:evaluate_guards => true})
#       not_if_action = double()
#       only_if_action = double()
#       file = Chef::Resource::File.new '/tmp/foo.txt'
#       file.not_if{ not_if_action.call }
#       file.only_if{ only_if_action.call }
#       not_if_action.should_receive(:call).once.and_return(false)
#       only_if_action.should_receive(:call).once.and_return(true)
#       file.stub(:run_context){ double.as_null_object }
#       file.run_action(:create)
#       expect(runner).to create_file '/tmp/foo.txt'
#     end
#   end

#   describe '#evaluate_guards?' do
#     it 'coerces evaluate_guards to a boolean' do
#       expect(
#         described_class.new({ evaluate_guards: :yeah }).evaluate_guards?
#       ).to be_true
#     end
#   end
# end
