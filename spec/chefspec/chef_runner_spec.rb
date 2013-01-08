require 'spec_helper'

module ChefSpec
  describe ChefRunner do
    describe "#initialize" do
      it "should create a node for use within the examples" do
        runner = ChefSpec::ChefRunner.new
        runner.node.should_not be_nil
      end
      it "should set the chef cookbook path to a default if not provided" do
        Chef::Config[:cookbook_path] = nil
        ChefSpec::ChefRunner.new
        Chef::Config[:cookbook_path].should_not be_nil
      end
      it "should set the chef cookbook path to any provided value" do
        ChefSpec::ChefRunner.new(:cookbook_path => '/tmp/foo')
        Chef::Config[:cookbook_path].should eql '/tmp/foo'
      end
      it "should support the chef cookbook path being passed as a string for backwards compatibility" do
        Chef::Config[:cookbook_path] = nil
        ChefSpec::ChefRunner.new('/tmp/bar')
        Chef::Config[:cookbook_path].should eql '/tmp/bar'
      end
      it "should default the log_level to warn" do
        Chef::Log.level.should eql :warn
      end
      it "should set the log_level to any provided value" do
        Chef::Log.stub(:info)
        ChefSpec::ChefRunner.new(:log_level => :info)
        Chef::Log.level.should eql :info
      end
      it "should alias the real resource actions" do
        ChefSpec::ChefRunner.new
        Chef::Resource::File.method_defined?(:old_run_action).should be
      end
      it "should capture the resources created" do
        runner = ChefSpec::ChefRunner.new
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.run_action(:create)
        runner.resources.size.should == 1
        runner.resources.first.should equal(file)
      end
      it "should execute the real action if resource is in the step_into list" do
        runner = ChefSpec::ChefRunner.new(:step_into => ['file'])
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.should_receive(:old_run_action).with(:create)
        file.run_action(:create)
      end
      it "should not execute not_if/only_if guards" do
        Chef::Platform.stub(:provider_for_resource) { stub.as_null_object }
        runner = ChefSpec::ChefRunner.new(:step_into => ['file'])
        not_if_action = double()
        only_if_action = double()
        file = Chef::Resource::File.new '/tmp/foo.txt'
        file.not_if { not_if_action.call }
        file.only_if { only_if_action.call }
        not_if_action.should_receive(:call).never
        only_if_action.should_receive(:call).never
        file.stub(:run_context) { stub.as_null_object }
        file.run_action(:create)
      end
      it "should accept a block to set node attributes" do
        runner = ChefSpec::ChefRunner.new() {|node| node.set[:foo] = 'baz'}
        runner.node.foo.should == 'baz'
      end
      context "default ohai attributes" do
        let(:node){ChefSpec::ChefRunner.new(platform:'chefspec', version:'0.6.1').node}
        specify{node['os'].should == 'chefspec'}
        specify{node['languages']['ruby'].should == "/usr/somewhere"}
        specify{node['os_version'].should == '0.6.1'}
        specify{node['fqdn'].should == 'chefspec.local'}
        specify{node['domain'].should == 'local'}
        specify{node['ipaddress'].should == '127.0.0.1'}
        specify{node['hostname'].should == 'chefspec'}
        specify{node['kernel']['machine'].should == 'i386'}
      end
      context "fauxhai delegation" do
        let(:node){ChefSpec::ChefRunner.new(platform:'ubuntu', version:'12.04').node}
        specify{node['os'].should == 'linux'}
        specify{node['languages']['ruby']['ruby_bin'].should == '/usr/local/bin/ruby'}
        specify{node['os_version'].should == '3.2.0-26-generic'}
        specify{node['fqdn'].should == 'fauxhai.local'}
        specify{node['domain'].should == 'local'}
        specify{node['ipaddress'].should == '10.0.0.2'}
        specify{node['hostname'].should == 'Fauxhai'}
        specify{node['kernel']['machine'].should == 'x86_64'}
      end
    end
    describe "#converge" do
      it "should rethrow the exception if a cookbook cannot be found" do
        expect { ChefSpec::ChefRunner.new.converge('non_existent::default') }.to raise_error
            (Chef::Exceptions::CookbookNotFound)
      end
      it "should return a reference to the runner" do
        ChefSpec::ChefRunner.new.converge.respond_to?(:resources).should be_true
      end
    end
    describe "#node" do
      it "should allow attributes to be set on the node" do
        runner = ChefSpec::ChefRunner.new
        runner.node.set[:foo] = 'bar'
        runner.node.foo.should eq 'bar'
      end
    end
    describe "#cookbook_file" do
      it "should not return a resource when the cookbook_file has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.cookbook_file('/tmp/foo.txt').should_not be
      end
      it "should return a resource when the cookbook_file has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'cookbook_file', :name => '/tmp/foo.txt'}]
        runner.cookbook_file('/tmp/foo.txt').should be
      end
    end
    describe "#template" do
      it "should not return a resource when the template has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.template('/tmp/foo.txt').should_not be
      end
      it "should return a resource when the template has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'template', :name => '/tmp/foo.txt'}]
        runner.template('/tmp/foo.txt').should be
      end
    end
    describe "#file" do
      it "should not return a resource when the file has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.file('/tmp/foo.txt').should_not be
      end
      it "should return a resource when the file has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'file', :name => '/tmp/foo.txt'}]
        runner.file('/tmp/foo.txt').should be
      end
    end
    describe "#directory" do
      it "should not return a resource when the directory has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.directory('/tmp').should_not be
      end
      it "should return a resource when the directory has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'directory', :name => '/tmp'}]
        runner.directory('/tmp').should be
      end
    end
    describe "#link" do
      it "should not return a resource when the link has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.link('/tmp').should_not be
      end
      it "should return a resource when the link has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'link', :name => '/tmp'}]
        runner.link('/tmp').should be
      end
    end
    describe "#cron" do
      it "should not return a resource when the cron has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.cron('daily_job').should_not be
      end
      it "should return a resource when the cron has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'cron', :name => 'daily_job'}]
        runner.cron('daily_job').should be
      end
    end
    describe "#env" do
      it "should not return a resource when no env resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.env('java_home').should_not be
      end
      it "should return a resource when the env resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'env', :name => 'java_home'}]
        runner.env('java_home').should be
      end
    end
    describe "#user" do
      it "should not return a resource when no user resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.user('foo').should_not be
      end
      it "should return a resource when the user resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'user', :name => 'foo'}]
        runner.user('foo').should be
      end
    end
    describe "#execute" do
      it "should not return a resource when no execute resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.execute('foo').should_not be
      end
      it "should return a resource when the execute resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'execute', :name => 'do_something'}]
        runner.execute('do_something').should be
      end
    end
    describe "#package" do
      it "should not return a resource when no package resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.package('foo').should_not be
      end
      it "should return a resource when the package resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'package', :name => 'foo'}]
        runner.package('foo').should be
      end
    end
    describe "#service" do
      it "should not return a resource when no service resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.service('foo').should_not be
      end
      it "should return a resource when the service resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'service', :name => 'foo'}]
        runner.service('foo').should be
      end
    end
    describe "#log" do
      it "should not return a resource when no log resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.log('foo').should_not be
      end
      it "should return a resource when the log resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'log', :name => 'foo'}]
        runner.log('foo').should be
      end
    end
    describe "#route" do
      it "should not return a resource when no route resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.route('foo').should_not be
      end
      it "should return a resource when the route resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'route', :name => 'foo'}]
        runner.route('foo').should be
      end
    end
    describe "#ruby_block" do
      it "should not return a resource when no ruby block resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.ruby_block('foo').should_not be
      end
      it "should return a resource when the ruby block resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'ruby_block', :name => 'foo'}]
        runner.ruby_block('foo').should be
      end
    end
    describe "#git" do
      it "should not return a resource when no git resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.git('foo').should_not be
      end
      it "should return a resource when the git resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'git', :name => 'foo'}]
        runner.git('foo').should be
      end
    end
    describe "#subversion" do
      it "should not return a resource when no subversion resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.subversion('foo').should_not be
      end
      it "should return a resource when the subversion resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'subversion', :name => 'foo'}]
        runner.subversion('foo').should be
      end
    end
    describe "#group" do
      it "should not return a resource when no group resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.group('foo').should_not be
      end
      it "should return a resource when the group resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'group', :name => 'foo'}]
        runner.group('foo').should be
      end
    end
    describe "#mount" do
      it "should not return a resource when no mount resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.mount('foo').should_not be
      end
      it "should return a resource when the mount resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'mount', :name => 'foo'}]
        runner.mount('foo').should be
      end
    end
    describe "#ohai" do
      it "should not return a resource when no ohai resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.ohai('foo').should_not be
      end
      it "should return a resource when the ohai resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'ohai', :name => 'foo'}]
        runner.ohai('foo').should be
      end
    end
    describe "#ifconfig" do
      it "should not return a resource when no ifconfig resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.ifconfig('eth0').should_not be
      end
      it "should return a resource when the ifconfig resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'ifconfig', :name => 'eth0'}]
        runner.ifconfig('eth0').should be
      end
    end
    describe "#deploy" do
      it "should not return a resource when no deploy resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.deploy('deploy').should_not be
      end
      it "should return a resource when the deploy resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'deploy', :name => 'foo'}]
        runner.deploy('foo').should be
      end
    end
    describe "#http_request" do
      it "should not return a resource when no http_request resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.http_request('foo').should_not be
      end
      it "should return a resource when the http_request resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'http_request', :name => 'foo'}]
        runner.http_request('foo').should be
      end
    end
    describe "#script" do
      it "should not return a resource when no script resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.script('foo').should_not be
      end
      it "should return a resource when the script resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'script', :name => 'foo'}]
        runner.script('foo').should be
      end
    end
    describe "#powershell" do
      it "should not return a resource when no powershell resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.powershell('foo').should_not be
      end
      it "should return a resource when the powershell resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'powershell', :name => 'foo'}]
        runner.powershell('foo').should be
      end
    end
    describe "#remote_directory" do
      it "should not return a resource when no remote directory resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.remote_directory('foo').should_not be
      end
      it "should return a resource when the remote directory resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'remote_directory', :name => 'foo'}]
        runner.remote_directory('foo').should be
      end
    end
    describe "#remote_file" do
      it "should not return a resource when no remote file resource has not been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = []
        runner.remote_file('foo').should_not be
      end
      it "should return a resource when the remote file resource has been declared" do
        runner = ChefSpec::ChefRunner.new
        runner.resources = [{:resource_name => 'remote_file', :name => 'foo'}]
        runner.remote_file('foo').should be
      end
    end
    describe "#to_s" do
      let(:chef_run) { ChefSpec::ChefRunner.new(:dry_run => true) }
      it "should override the default string representation to something readable" do
        chef_run.converge('apache2::default').to_s.should == 'chef_run: recipe[apache2::default]'
      end
      it "should be ok when a convergence has not yet taken place" do
        chef_run.to_s.should == 'chef_run'
      end
      it "should not include node attributes" do
        chef_run.node.set[:foo] = 'bar'
        chef_run.node.automatic_attrs[:platform] = 'solaris'
        chef_run.converge('apache2::default').to_s.should == 'chef_run: recipe[apache2::default]'
      end
      it "should include the entire run_list" do
        chef_run.converge('apache2::default', 'apache2::mod_ssl').to_s.should == 'chef_run: recipe[apache2::default], recipe[apache2::mod_ssl]'
      end
      it "should have the run_list only for the last convergence" do
        ['mysql::client', 'mysql::server'].each {|recipe| chef_run.converge recipe}
        chef_run.to_s.should == 'chef_run: recipe[mysql::server]'
      end
    end
  end
end
