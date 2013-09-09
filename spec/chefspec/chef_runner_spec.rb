require 'spec_helper'

module ChefSpec
  describe ChefRunner do
    describe '#initialize' do
      it 'creates a node for use within the examples' do
        runner = ChefSpec::ChefRunner.new
        expect(runner.node).not_to be_nil
      end

      it 'sets the chef cookbook path to a default if not provided' do
        Chef::Config[:cookbook_path] = nil
        ChefSpec::ChefRunner.new
        expect(Chef::Config[:cookbook_path]).not_to be_nil
      end

      it 'sets the chef cookbook path to any provided value' do
        File.stub(:exists?).and_return(false)
        File.stub(:exists?).with('/tmp/foo').and_return(true)
        ChefSpec::ChefRunner.new(cookbook_path: '/tmp/foo')
        expect(Chef::Config[:cookbook_path]).to eq(['/tmp/foo'])
      end

      it 'supports the Chef cookbook path being passed as a string for backwards compatibility' do
        File.stub(:exists?).and_return(false)
        Chef::Config[:cookbook_path] = nil
        File.stub(:exists?).with('/tmp/bar').and_return(true)
        ChefSpec::ChefRunner.new('/tmp/bar')
        expect(Chef::Config[:cookbook_path]).to eq(['/tmp/bar'])
      end

      it 'defaults the log_level to warn' do
        expect(Chef::Log.level).to eq(:warn)
      end

      it 'sets the log_level to any provided value' do
        Chef::Log.stub(:info)
        ChefSpec::ChefRunner.new(log_level: :info)
        expect(Chef::Log.level).to eq(:info)
      end

      it 'aliases the real resource actions' do
        ChefSpec::ChefRunner.new
        expect(Chef::Resource::File).to be_method_defined(:old_run_action)
      end

      it 'captures the resources created' do
        runner = ChefSpec::ChefRunner.new
        file = Chef::Resource::File.new('/tmp/foo.txt')
        file.run_action(:create)
        expect(runner.resources.size).to eq 1
        expect(runner.resources.first).to equal(file)
      end

      it 'executes the real action if resource is in the step_into list' do
        runner = ChefSpec::ChefRunner.new(step_into: ['file'])
        file = Chef::Resource::File.new('/tmp/foo.txt')
        file.should_receive(:old_run_action).with(:create)
        file.run_action(:create)
      end

      context 'stepping into lwrps' do
        before do
          Chef::Platform.stub(:provider_for_resource) { double.as_null_object }
        end

        let(:not_if_action) { double }
        let(:only_if_action) { double }
        let(:file) do
          file = Chef::Resource::File.new('/tmp/foo.txt')
          file.not_if { not_if_action.call }
          file.only_if { only_if_action.call }
          file
        end

        it 'does not execute not_if/only_if guards' do
          runner = ChefSpec::ChefRunner.new(step_into: ['file'])
          not_if_action.should_receive(:call).never
          only_if_action.should_receive(:call).never
          file.stub(:run_context) { double.as_null_object }
          file.run_action(:create)
        end

        it 'executes not_if/only_if guards if asked to' do
          ChefSpec::ChefRunner.new(step_into: ['file'], evaluate_guards: true)
          not_if_action.should_receive(:call).once.and_return(false)
          only_if_action.should_receive(:call).once.and_return(true)
          file.stub(:run_context){ double.as_null_object }
          file.run_action(:create)
        end
      end

      it 'accepts a block to set node attributes' do
        runner = ChefSpec::ChefRunner.new { |node| node.set[:foo] = 'baz' }.node.to_hash
        expect(runner['foo']).to eq('baz')
      end

      context 'default ohai attributes' do
        let(:hash) { ChefSpec::ChefRunner.new(platform: 'chefspec', version: '0.6.1').node.to_hash }

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

      context 'fauxhai delegation' do
        let(:hash) { ChefSpec::ChefRunner.new(platform: 'ubuntu', version: '12.04').node.to_hash }

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

      it 'allows evaluate_guards to be falsey' do
        expect(
          ChefSpec::ChefRunner.new({ evaluate_guards: false}).evaluate_guards?
        ).to be_false
      end

      it 'allows evaluate_guards to be truthy' do
        expect(
          ChefSpec::ChefRunner.new({ evaluate_guards: true }).evaluate_guards?
        ).to be_true
      end
    end

    describe '#stub_command' do
      let(:chef_run) { ChefSpec::ChefRunner.new }

      it 'allows a stub to be defined as a string' do
        chef_run.stub_command('which blah', false)
        expect(chef_run.stubbed_commands).to include(['which blah', false])
      end

      it 'allows a stub to be defined as a regex' do
        chef_run.stub_command(/which/, false)
        expect(chef_run.stubbed_commands).to include([/which/, false])
      end

      it 'allows multiple commands to be stubbed' do
        chef_run.stub_command(/which/, false)
        chef_run.stub_command(/grep/, true)
        expect(chef_run.stubbed_commands).to include([/which/, false])
        expect(chef_run.stubbed_commands).to include([/grep/, true])
      end
    end

    describe '#converge' do
      let(:chef_run) { ChefSpec::ChefRunner.new }

      it 'rethrows the exception if a cookbook cannot be found' do
        expect {
          chef_run.converge('non_existent::default')
        }.to raise_error(Chef::Exceptions::CookbookNotFound)
      end

      it 'returns a reference to the runner' do
        expect(chef_run.converge).to be_a(ChefSpec::ChefRunner)
      end
      it "should not execute guards by default" do
        Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
        runner = ChefSpec::ChefRunner.new
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).never
        only_if_action.should_receive(:call).never
        file.stub(:run_context){ double.as_null_object }
        file.run_action(:create)
      end
      it "should not execute ruby guards if explicitly asked not to" do
        Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => false})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).never
        only_if_action.should_receive(:call).never
        file.stub(:run_context){ double.as_null_object }
        file.run_action(:create)
      end
      it "should execute ruby guards if asked to" do
        Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => true})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).once.and_return(false)
        only_if_action.should_receive(:call).once.and_return(true)
        file.stub(:run_context){ double.as_null_object }
        file.run_action(:create)
      end
      context "executing shell guards" do
        before :each do
          Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
          ChefSpec::ChefRunner.new({:evaluate_guards => true})
        end
        let(:file) do
          file = Chef::Resource::File.new '/tmp/foo.txt'
          file.stub(:run_context){ double.as_null_object }
          file
        end
        it "raises if a not_if shell guard has not been stubbed" do
          file.not_if "non-existent-command"
          expect{ file.run_action(:create)}.to raise_error(
            RSpec::Mocks::MockExpectationError,
            'The following shell guard was unstubbed: not_if command `non-existent-command`')
        end
        it "raises if an only_if shell guard has not been stubbed" do
          file.only_if "ls"
          expect{ file.run_action(:create)}.to raise_error(
            RSpec::Mocks::MockExpectationError,
            'The following shell guard was unstubbed: only_if command `ls`')
        end
        it "raises if a stub is provided that doesn't match" do
          file.only_if "ls"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command('dir', false)
          expect{ file.run_action(:create)}.to raise_error(
            RSpec::Mocks::MockExpectationError,
            'The following shell guard was unstubbed: only_if command `ls`')
        end
        context "actually evaluating shell guards" do
          it "doesn't actually run shell guards" do
            file.only_if "non-existent-command"
            chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
            Chef::Resource::Conditional.any_instance.should_not_receive(
              :original_evaluate_command)
            expect{ file.run_action(:create)}.to raise_error(
              RSpec::Mocks::MockExpectationError,
              'The following shell guard was unstubbed: only_if command `non-existent-command`')
          end
          it "uses stubs in preference to the actual command if defined" do
            file.only_if "ls"
            Chef::Resource::Conditional.any_instance.should_not_receive(
              :original_evaluate_command)
            chef_run = ChefSpec::ChefRunner.new(
              {:evaluate_guards => true, :actually_run_shell_guards => true})
            chef_run.stub_command('ls', true)
            file.run_action(:create)
            expect(chef_run).to create_file '/tmp/foo.txt'
          end
          it "runs shell guards that are not stubbed if explicitly asked to" do
            file.only_if "non-existent-command"
            chef_run = ChefSpec::ChefRunner.new(
              {:evaluate_guards => true, :actually_run_shell_guards => true})
            Chef::Resource::Conditional.any_instance.should_receive(
              :original_evaluate_command).and_return(true)
            file.run_action(:create)
            expect(chef_run).to create_file '/tmp/foo.txt'
          end
        end
        it "omits the resource if the guard is failed" do
          file.only_if "which foo"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command('which foo', false)
          file.run_action(:create)
          expect(chef_run).to_not create_file '/tmp/foo.txt'
        end
        it "includes the resource if the guard is passed (string stub)" do
          file.only_if "which foo"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command('which foo', true)
          file.run_action(:create)
          expect(chef_run).to create_file '/tmp/foo.txt'
        end
        it "includes the resource if the guard is passed (regex stub)" do
          file.only_if "which foo"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command(/which/, true)
          file.run_action(:create)
          expect(chef_run).to create_file '/tmp/foo.txt'
        end
        it "stubs multiple conditionals from multiple stubs" do
          file.only_if "which foo"
          file.only_if "which baz"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command(/foo/, true)
          chef_run.stub_command(/baz/, true)
          file.run_action(:create)
          expect(chef_run).to create_file '/tmp/foo.txt'
        end
        it "stubs multiple conditionals from a single stub if they match" do
          file.only_if "which foo"
          file.only_if "which baz"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command(/which/, true)
          file.run_action(:create)
          expect(chef_run).to create_file '/tmp/foo.txt'
        end
        it "applies stubs in the order in which they are stubbed" do
          file.only_if "which azimuth"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command(/zi/, true)
          chef_run.stub_command(/a/, false)
          file.run_action(:create)
          expect(chef_run).to create_file '/tmp/foo.txt'
        end
        it "allows stub results to be replaced if the commands are identical" do
          file.only_if "which azimuth"
          chef_run = ChefSpec::ChefRunner.new({:evaluate_guards => true})
          chef_run.stub_command(/a/, true)
          chef_run.stub_command(/a/, false)
          file.run_action(:create)
          expect(chef_run).not_to create_file '/tmp/foo.txt'
        end
      end
      it "omits the resource if the guard is failed" do
        Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => true})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.only_if{ only_if_action.call }
        only_if_action.should_receive(:call).once.and_return(false)
        file.stub(:run_context){ double.as_null_object }
        file.run_action(:create)
        expect(runner).to_not create_file '/tmp/foo.txt'
      end
      it "includes the resource if the guard is passed" do
        Chef::Platform.stub(:provider_for_resource){ double.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => true})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).once.and_return(false)
        only_if_action.should_receive(:call).once.and_return(true)
        file.stub(:run_context){ double.as_null_object }
        file.run_action(:create)
        expect(runner).to create_file '/tmp/foo.txt'
      end
    end

    describe '#evaluate_guards?' do
      it 'coerces evaluate_guards to a boolean' do
        expect(
          ChefSpec::ChefRunner.new({ evaluate_guards: :yeah }).evaluate_guards?
        ).to be_true
      end
    end

    describe '#node' do
      it 'allows attributes to be set on the node' do
        runner = ChefSpec::ChefRunner.new
        runner.node.set[:foo] = 'bar'
        expect(runner.node.foo).to eq('bar')
      end
    end

    %w(
      cookbook_file
      cron
      deploy
      directory
      env
      execute
      file
      git
      group
      http_request
      ifconfig
      link
      log
      mount
      ohai
      package
      powershell
      remote_directory
      remote_file
      route
      ruby_block
      script
      service
      subversion
      template
      user
    ).each do |matcher|
      describe "##{matcher}" do
        let(:chef_run) { ChefSpec::ChefRunner.new }

        it "does not return a resource when no #{matcher}s have been declared" do
          expect(chef_run.send(matcher, 'value')).to be_nil
        end

        it "returns the resource when a #{matcher} exists" do
          chef_run.resources = [{ resource_name: matcher, name: 'value' }]
          expect(chef_run.send(matcher, 'value')).to_not be_nil
        end
      end
    end

    describe '#to_s' do
      let(:chef_run) { ChefSpec::ChefRunner.new(dry_run: true) }

      it 'overrides the default string representation to something readable' do
        expect(chef_run.converge('apache2::default').to_s).to eq('chef_run: recipe[apache2::default]')
      end

      it 'is ok when a convergence has not yet taken place' do
        expect(chef_run.to_s).to eq('chef_run')
      end

      it 'includes the entire run_list' do
        expect(chef_run.converge('apache2::default', 'apache2::mod_ssl').to_s).to eq('chef_run: recipe[apache2::default], recipe[apache2::mod_ssl]')
      end

      it 'has the run_list only for the last convergence' do
        ['mysql::client', 'mysql::server'].each { |recipe| chef_run.converge(recipe) }
        expect(chef_run.to_s).to eq('chef_run: recipe[mysql::server]')
      end
    end
  end
end
