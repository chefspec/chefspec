require 'spec_helper'

module ChefSpec
  describe ChefRunner do
    describe "#initialize" do
      before do
        File.stub(:exists?).and_return(false)
      end
      it "should create a node for use within the examples" do
        runner = ChefSpec::ChefRunner.new
        expect(runner.node).not_to be_nil
      end
      it "should set the chef cookbook path to a default if not provided" do
        Chef::Config[:cookbook_path] = nil
        ChefSpec::ChefRunner.new
        expect(Chef::Config[:cookbook_path]).not_to be_nil
      end
      it "should set the chef cookbook path to any provided value" do
        File.stub(:exists?).with('/tmp/foo').and_return(true)
        ChefSpec::ChefRunner.new(:cookbook_path => '/tmp/foo')
        expect(Chef::Config[:cookbook_path]).to eql ['/tmp/foo']
      end
      it "should support the chef cookbook path being passed as a string for backwards compatibility" do
        Chef::Config[:cookbook_path] = nil
        File.stub(:exists?).with('/tmp/bar').and_return(true)
        ChefSpec::ChefRunner.new('/tmp/bar')
        expect(Chef::Config[:cookbook_path]).to eql ['/tmp/bar']
      end
      it "should default the log_level to warn" do
        expect(Chef::Log.level).to eql :warn
      end
      it "should set the log_level to any provided value" do
        Chef::Log.stub(:info)
        ChefSpec::ChefRunner.new(:log_level => :info)
        expect(Chef::Log.level).to eql :info
      end
      it "should alias the real resource actions" do
        ChefSpec::ChefRunner.new
        expect(Chef::Resource::File.method_defined?(:old_run_action)).to be
      end
      it "should capture the resources created" do
        runner = ChefSpec::ChefRunner.new
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.run_action(:create)
        expect(runner.resources.size).to eq 1
        expect(runner.resources.first).to equal(file)
      end
      it "should execute the real action if resource is in the step_into list" do
        runner = ChefSpec::ChefRunner.new(:step_into => ['file'])
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.should_receive(:old_run_action).with(:create)
        file.run_action(:create)
      end
      context "stepping into lwrps" do
        before :each do
          Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
        end
        let(:not_if_action){ double }
        let(:only_if_action){ double }
        let(:file) do
          file = Chef::Resource::File.new '/tmp/foo.txt'
          file.not_if{ not_if_action.call }
          file.only_if{ only_if_action.call }
          file
        end
        it "should not execute not_if/only_if guards" do
          runner = ChefSpec::ChefRunner.new(:step_into => ['file'])
          not_if_action.should_receive(:call).never
          only_if_action.should_receive(:call).never
          file.stub(:run_context){ stub.as_null_object }
          file.run_action(:create)
        end
        it "should execute not_if/only_if guards if asked to" do
          ChefSpec::ChefRunner.new(:step_into => ['file'],
                                   :evaluate_guards => true)
          not_if_action.should_receive(:call).once.and_return(false)
          only_if_action.should_receive(:call).once.and_return(true)
          file.stub(:run_context){ stub.as_null_object }
          file.run_action(:create)
        end
      end
      it "should accept a block to set node attributes" do
        runner = ChefSpec::ChefRunner.new() {|node| node.set[:foo] = 'baz'}
        expect(runner.node.foo).to eq 'baz'
      end
      context "default ohai attributes" do
        let(:node){ChefSpec::ChefRunner.new(:platform => 'chefspec', :version => '0.6.1').node}
        specify{node['os'] == 'chefspec'}
        specify{node['languages']['ruby'] == "/usr/somewhere"}
        specify{node['os_version'] == '0.6.1'}
        specify{node['fqdn'] == 'chefspec.local'}
        specify{node['domain'] == 'local'}
        specify{node['ipaddress'] == '127.0.0.1'}
        specify{node['hostname'] == 'chefspec'}
        specify{node['kernel']['machine'] == 'i386'}
      end
      context "fauxhai delegation" do
        let(:node){ChefSpec::ChefRunner.new(:platform => 'ubuntu', :version => '12.04').node}
        specify{node['os'] == 'linux'}
        specify{node['languages']['ruby']['ruby_bin'] == '/usr/local/bin/ruby'}
        specify{node['os_version'] == '3.2.0-26-generic'}
        specify{node['fqdn'] == 'fauxhai.local'}
        specify{node['domain'] == 'local'}
        specify{node['ipaddress'] == '10.0.0.2'}
        specify{node['hostname'] == 'Fauxhai'}
        specify{node['kernel']['machine'] == 'x86_64'}
      end
      it "should allow evaluate_guards to be falsey" do
        expect(
          ChefSpec::ChefRunner.new({:evaluate_guards => false}).evaluate_guards?
        ).to be_false
      end
      it "should allow evaluate_guards to be truthy" do
        expect(
          ChefSpec::ChefRunner.new({:evaluate_guards => true}).evaluate_guards?
        ).to be_true
      end
    end
    describe "#converge" do
      it "should rethrow the exception if a cookbook cannot be found" do
        expect { ChefSpec::ChefRunner.new.converge('non_existent::default') }.to raise_error
            (Chef::Exceptions::CookbookNotFound)
      end
      it "should return a reference to the runner" do
        expect(ChefSpec::ChefRunner.new.converge.respond_to?(:resources)).to be_true
      end
      it "should not execute guards by default" do
        Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
        runner = ChefSpec::ChefRunner.new
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).never
        only_if_action.should_receive(:call).never
        file.stub(:run_context){ stub.as_null_object }
        file.run_action(:create)
      end
      it "should not execute ruby guards if explicitly asked not to" do
        Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => false})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).never
        only_if_action.should_receive(:call).never
        file.stub(:run_context){ stub.as_null_object }
        file.run_action(:create)
      end
      it "should execute ruby guards if asked to" do
        Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => true})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).once.and_return(false)
        only_if_action.should_receive(:call).once.and_return(true)
        file.stub(:run_context){ stub.as_null_object }
        file.run_action(:create)
      end
      context "executing shell guards" do
        before :each do
          Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
          ChefSpec::ChefRunner.new({:evaluate_guards => true})
        end
        let(:file) do
          file = Chef::Resource::File.new '/tmp/foo.txt'
          file.stub(:run_context){ stub.as_null_object }
          file
        end
        it "evaluates not_if" do
          file.not_if "non-existent-command"
          Chef::Resource::Conditional.any_instance.should_receive(
            :evaluate_command).and_return(false)
          file.run_action(:create)
        end
        it "evaluates only_if" do
          file.only_if "ls"
          Chef::Resource::Conditional.any_instance.should_receive(
            :evaluate_command).and_return(true)
          file.run_action(:create)
        end
      end
      it "omits the resource if the guard is failed" do
        Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => true})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.only_if{ only_if_action.call }
        only_if_action.should_receive(:call).once.and_return(false)
        file.stub(:run_context){ stub.as_null_object }
        file.run_action(:create)
        expect(runner).to_not create_file '/tmp/foo.txt'
      end
      it "includes the resource if the guard is passed" do
        Chef::Platform.stub(:provider_for_resource){ stub.as_null_object }
        runner = ChefSpec::ChefRunner.new({:evaluate_guards => true})
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if{ not_if_action.call }
        file.only_if{ only_if_action.call }
        not_if_action.should_receive(:call).once.and_return(false)
        only_if_action.should_receive(:call).once.and_return(true)
        file.stub(:run_context){ stub.as_null_object }
        file.run_action(:create)
        expect(runner).to create_file '/tmp/foo.txt'
      end
    end
    describe "#evaluate_guards?" do
      it "should coerce evaluate_guards to a boolean" do
        expect(ChefSpec::ChefRunner.new(
          {:evaluate_guards => :yeah}).evaluate_guards?).to eq(true)
      end
    end
    describe "#node" do
      it "should allow attributes to be set on the node" do
        runner = ChefSpec::ChefRunner.new
        runner.node.set[:foo] = 'bar'
        expect(runner.node.foo).to eq 'bar'
      end
    end
    describe "#cookbook_file" do
      it "should not return a resource when the cookbook_file has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.cookbook_file('/tmp/foo.txt')).not_to be
      end
      it "should return a resource when the cookbook_file has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'cookbook_file', :name => '/tmp/foo.txt'}]
        expect(runner.cookbook_file('/tmp/foo.txt')).to be
      end
    end
    describe "#template" do
      it "should not return a resource when the template has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.template('/tmp/foo.txt')).not_to be
      end
      it "should return a resource when the template has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'template', :name => '/tmp/foo.txt'}]
        expect(runner.template('/tmp/foo.txt')).to be
      end
    end
    describe "#file" do
      it "should not return a resource when the file has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.file('/tmp/foo.txt')).not_to be
      end
      it "should return a resource when the file has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'file', :name => '/tmp/foo.txt'}]
        expect(runner.file('/tmp/foo.txt')).to be
      end
    end
    describe "#directory" do
      it "should not return a resource when the directory has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.directory('/tmp')).not_to be
      end
      it "should return a resource when the directory has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'directory', :name => '/tmp'}]
        expect(runner.directory('/tmp')).to be
      end
    end
    describe "#link" do
      it "should not return a resource when the link has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.link('/tmp')).not_to be
      end
      it "should return a resource when the link has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'link', :name => '/tmp'}]
        expect(runner.link('/tmp')).to be
      end
    end
    describe "#cron" do
      it "should not return a resource when the cron has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.cron('daily_job')).not_to be
      end
      it "should return a resource when the cron has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'cron', :name => 'daily_job'}]
        expect(runner.cron('daily_job')).to be
      end
    end
    describe "#env" do
      it "should not return a resource when no env resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.env('java_home')).not_to be
      end
      it "should return a resource when the env resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'env', :name => 'java_home'}]
        expect(runner.env('java_home')).to be
      end
    end
    describe "#user" do
      it "should not return a resource when no user resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.user('foo')).not_to be
      end
      it "should return a resource when the user resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'user', :name => 'foo'}]
        expect(runner.user('foo')).to be
      end
    end
    describe "#execute" do
      it "should not return a resource when no execute resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.execute('foo')).not_to be
      end
      it "should return a resource when the execute resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'execute', :name => 'do_something'}]
        expect(runner.execute('do_something')).to be
      end
    end
    describe "#package" do
      it "should not return a resource when no package resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.package('foo')).not_to be
      end
      it "should return a resource when the package resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'package', :name => 'foo'}]
        expect(runner.package('foo')).to be
      end
    end
    describe "#service" do
      it "should not return a resource when no service resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.service('foo')).not_to be
      end
      it "should return a resource when the service resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'service', :name => 'foo'}]
        expect(runner.service('foo')).to be
      end
    end
    describe "#log" do
      it "should not return a resource when no log resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.log('foo')).not_to be
      end
      it "should return a resource when the log resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'log', :name => 'foo'}]
        expect(runner.log('foo')).to be
      end
    end
    describe "#route" do
      it "should not return a resource when no route resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.route('foo')).not_to be
      end
      it "should return a resource when the route resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'route', :name => 'foo'}]
        expect(runner.route('foo')).to be
      end
    end
    describe "#ruby_block" do
      it "should not return a resource when no ruby block resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.ruby_block('foo')).not_to be
      end
      it "should return a resource when the ruby block resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'ruby_block', :name => 'foo'}]
        expect(runner.ruby_block('foo')).to be
      end
    end
    describe "#git" do
      it "should not return a resource when no git resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.git('foo')).not_to be
      end
      it "should return a resource when the git resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'git', :name => 'foo'}]
        expect(runner.git('foo')).to be
      end
    end
    describe "#subversion" do
      it "should not return a resource when no subversion resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.subversion('foo')).not_to be
      end
      it "should return a resource when the subversion resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'subversion', :name => 'foo'}]
        expect(runner.subversion('foo')).to be
      end
    end
    describe "#group" do
      it "should not return a resource when no group resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.group('foo')).not_to be
      end
      it "should return a resource when the group resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'group', :name => 'foo'}]
        expect(runner.group('foo')).to be
      end
    end
    describe "#mount" do
      it "should not return a resource when no mount resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.mount('foo')).not_to be
      end
      it "should return a resource when the mount resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'mount', :name => 'foo'}]
        expect(runner.mount('foo')).to be
      end
    end
    describe "#ohai" do
      it "should not return a resource when no ohai resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.ohai('foo')).not_to be
      end
      it "should return a resource when the ohai resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'ohai', :name => 'foo'}]
        expect(runner.ohai('foo')).to be
      end
    end
    describe "#ifconfig" do
      it "should not return a resource when no ifconfig resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.ifconfig('eth0')).not_to be
      end
      it "should return a resource when the ifconfig resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'ifconfig', :name => 'eth0'}]
        expect(runner.ifconfig('eth0')).to be
      end
    end
    describe "#deploy" do
      it "should not return a resource when no deploy resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.deploy('deploy')).not_to be
      end
      it "should return a resource when the deploy resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'deploy', :name => 'foo'}]
        expect(runner.deploy('foo')).to be
      end
    end
    describe "#http_request" do
      it "should not return a resource when no http_request resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.http_request('foo')).not_to be
      end
      it "should return a resource when the http_request resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'http_request', :name => 'foo'}]
        expect(runner.http_request('foo')).to be
      end
    end
    describe "#script" do
      it "should not return a resource when no script resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.script('foo')).not_to be
      end
      it "should return a resource when the script resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'script', :name => 'foo'}]
        expect(runner.script('foo')).to be
      end
    end
    describe "#powershell" do
      it "should not return a resource when no powershell resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.powershell('foo')).not_to be
      end
      it "should return a resource when the powershell resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'powershell', :name => 'foo'}]
        expect(runner.powershell('foo')).to be
      end
    end
    describe "#remote_directory" do
      it "should not return a resource when no remote directory resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.remote_directory('foo')).not_to be
      end
      it "should return a resource when the remote directory resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'remote_directory', :name => 'foo'}]
        expect(runner.remote_directory('foo')).to be
      end
    end
    describe "#remote_file" do
      it "should not return a resource when no remote file resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        expect(runner.remote_file('foo')).not_to be
      end
      it "should return a resource when the remote file resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'remote_file', :name => 'foo'}]
        expect(runner.remote_file('foo')).to be
      end
    end
    describe "#to_s" do
      let(:chef_run) { ChefSpec::ChefRunner.new(:dry_run => true) }
      it "should override the default string representation to something readable" do
        expect(chef_run.converge('apache2::default').to_s).to eq 'chef_run: recipe[apache2::default]'
      end
      it "should be ok when a convergence has not yet taken place" do
        expect(chef_run.to_s).to eq 'chef_run'
      end
      it "should not include node attributes" do
        chef_run.node.set[:foo] = 'bar'
        chef_run.node.automatic_attrs[:platform] = 'solaris'
        expect(chef_run.converge('apache2::default').to_s).to eq 'chef_run: recipe[apache2::default]'
      end
      it "should include the entire run_list" do
        expect(chef_run.converge('apache2::default', 'apache2::mod_ssl').to_s).to eq 'chef_run: recipe[apache2::default], recipe[apache2::mod_ssl]'
      end
      it "should have the run_list only for the last convergence" do
        ['mysql::client', 'mysql::server'].each {|recipe| chef_run.converge recipe}
        expect(chef_run.to_s).to eq 'chef_run: recipe[mysql::server]'
      end
    end
  end
end
