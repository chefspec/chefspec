module ChefSpec
  module RSpecHelpers

    def assert_example_generated(cookbook_name, recipe_name)
      check_directory_presence ["#{cookbook_name}/spec"], true
      check_file_presence ["#{cookbook_name}/spec/#{recipe_name}_spec.rb"], true
      check_file_content "#{cookbook_name}/spec/#{recipe_name}_spec.rb",
        "describe '#{cookbook_name}::#{recipe_name}'", true
    end

    def assert_no_examples_run
      run_simple('rspec my_new_cookbook')
      assert_partial_output 'No examples found.', all_output
    end

    def run_examples_successfully
      run_simple 'rspec cookbooks/example/spec/'
      assert_success(true)
      assert_partial_output ', 0 failures', all_output
    end

    def run_examples_unsuccessfully(failure_message)
      run_simple 'rspec cookbooks/example/spec/', false
      assert_success(false)
      Array(failure_message).each do |failure|
        assert_partial_output failure, all_output
      end
    end

    def spec_already_exists
      write_file 'cookbooks/my_existing_cookbook/recipes/default.rb', %q{
        execute "print_hello_world" do
          command "echo Hello World!"
          action :run
        end
      }
      write_file 'cookbooks/my_existing_cookbook/spec/default_spec.rb', %q{
        require "chefspec"

        # I am an existing example - please don't overwrite me!
        describe "my_existing_cookbook::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "prints hello world" do
            expect(chef_run).to execute_command('echo Hello World!')
          end
        end
      }
    end

    def spec_example_is_pending?
      run_simple 'rspec my_new_cookbook'
      ["Pending", "my_new_cookbook::default should do something",
        "# Your recipe examples go here.", "1 example, 0 failures, 1 pending"].all? do |content|
        all_output.include? content
      end
    end

    def spec_existing_example_not_overwritten?
      check_file_content "cookbooks/my_existing_cookbook/spec/default_spec.rb",
        "# I am an existing example - please don't overwrite me!", true
    end

    def spec_expects_command
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "prints hello world" do
            expect(chef_run).to execute_command('echo Hello World!').with(
              :cwd => '/tmp',
              :creates => '/tmp/foo'
            )
          end
        end
      }
    end

    def spec_expects_directory
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "creates the directory" do
            expect(chef_run).to create_directory('foo')
          end
        end
      }
    end

    def spec_expects_directory_to_be_deleted
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "deletes the directory" do
            expect(chef_run).to delete_directory('foo')
          end
        end
      }
    end

    def spec_expects_directory_with_ownership
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "sets directory ownership" do
            expect(chef_run.directory('foo')).to be_owned_by('user', 'group')
          end
        end
      }
    end

    def spec_expects_file(resource_type, path = 'hello-world.txt')
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "creates hello-world.txt" do
            expect(chef_run).to create_#{resource_type.to_s}('#{path}')
          end
        end
      }
    end

    def spec_expects_file_to_be_deleted
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "deletes hello-world.txt" do
            expect(chef_run).to delete_file('hello-world.txt')
          end
        end
      }
    end

    def spec_expects_file_with_args(options = {})
      stubbing = if options[:stub] && ! options[:stub].empty?
        "chef_run.stub_command(#{options[:stub]}, #{options[:stub_result]})"
      else
        ''
      end
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) do
            chef_run = ChefSpec::ChefRunner.new(#{Hash[options[:constructor_args]].inspect})
            #{stubbing}
            chef_run.converge 'example::default'
          end
          it "#{options[:be_declared]}" do
            expect(chef_run).#{options[:expectation]} create_file("/tmp/foo")
          end
        end
      }
    end

    def spec_expects_file_with_content
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "creates hello-world.txt" do
            expect(chef_run).to create_file_with_content('hello-world.txt', 'hello world')
          end
        end
      }
    end

    def spec_expects_file_with_rendered_content(partial=false)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"
        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "creates a file with the node platform" do
            expected_content = <<-EOF.gsub /^\s*/, ''
              # Config file generated by Chef
              platform: chefspec#{', foo: chefspec' if partial}
            EOF
            expect(chef_run).to create_file_with_content('/etc/config_file', expected_content)
          end
        end
      }
    end

    def spec_expects_file_with_ownership(resource_type)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "sets file ownership" do
            expect(chef_run.#{resource_type.to_s}('hello-world.txt')).to be_owned_by('user', 'group')
          end
        end
      }
    end

    def spec_expects_gem_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s package_does_not_exist" do
            expect(chef_run).to #{action.to_s}_gem_package('gem_package_does_not_exist')
          end
        end
      }
    end

    def spec_expects_gem_at_specific_version
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "installs gem_package_does_not_exist at a specific version" do
            expect(chef_run).to install_gem_package_at_version('gem_package_does_not_exist', '1.2.3')
          end
        end
      }
    end

    def spec_expects_chef_gem_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s package_does_not_exist" do
            expect(chef_run).to #{action.to_s}_chef_gem('chef_gem_does_not_exist')
          end
        end
      }
    end

    def spec_expects_chef_gem_at_specific_version
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "installs chef_gem_does_not_exist at a specific version" do
            expect(chef_run).to install_chef_gem_at_version('chef_gem_does_not_exist', '1.2.3')
          end
        end
      }
    end

    def spec_expects_package_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s package_does_not_exist" do
            expect(chef_run).to #{action.to_s}_package('package_does_not_exist')
          end
        end
      }
    end

    def spec_expects_package_at_specific_version
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) {ChefSpec::ChefRunner.new.converge 'example::default'}
          it "installs package_does_not_exist at a specific version" do
            expect(chef_run).to install_package_at_version('package_does_not_exist', '1.2.3')
          end
        end
      }
    end

    def spec_expects_service_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s the food service" do
            expect(chef_run).to #{action.to_s}_service('food')
          end
        end
      }
    end

    def spec_expects_only_restart_service_action
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "only restarts the food service" do
            expect(chef_run).to restart_service('food')
            expect(chef_run).to_not start_service('food')
          end
        end
      }
    end

    def spec_expects_service_to_be_started_and_enabled
      write_file 'cookbooks/example/spec/default_spec.rb', %q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "ensures the food service is started and enabled" do
            expect(chef_run).to start_service('food')
            expect(chef_run).to set_service_to_start_on_boot('food')
          end
        end
      }
    end

    def spec_generate_examples(type)
      run_simple("knife cookbook create_specs -o . my_#{type.to_s}_cookbook")
      assert_success(true)
    end

    def spec_overrides_operating_system(operating_system)
      @operating_system = operating_system
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new(:log_level => :debug) }
          it "logs the node platform" do
            chef_run.node.automatic_attrs[:platform] = '#{operating_system}'
            expect(chef_run.converge('example::default')).to log('I am running on the #{operating_system} platform.')
          end
        end
      }
    end

    def spec_sets_node_attribute
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) do
            ChefSpec::ChefRunner.new(:log_level => :debug) do |node|
              node.set['foo'] = 'bar'
            end.converge 'example::default'
          end
          it "logs the node foo" do
            expect(chef_run).to log(/node.foo is: bar$/)
          end
        end
      }
    end

    def spec_expects_lwrp_to_greet(constructor_args = [], expectation = 'to')
      constructor_args << [:step_into, ['example']]
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) do
            ChefSpec::ChefRunner.new(#{Hash[constructor_args].inspect}).converge 'example::default'
          end
          it "greets" do
            expect(chef_run).#{expectation} execute_command("echo Hello Foobar!")
          end
          it "does not say hello world" do
            expect(chef_run).not_to execute_command("echo Hello World!")
          end
        end
      }
    end

    def spec_expects_user_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s the user foo" do
            expect(chef_run).to #{action.to_s}_user('foo')
          end
        end
      }
    end

    def spec_uses_user_convenience_method
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "uses the user convenience method" do
            expect(chef_run.user('foo')).to_not be_nil
          end
        end
      }
    end

    def spec_expects_group_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s the group foo" do
            expect(chef_run).to #{action.to_s}_group('foo')
          end
        end
      }
    end

    def spec_uses_group_convenience_method
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "uses the group convenience method" do
            expect(chef_run.group('foo')).to_not be_nil
          end
        end
      }
    end

    def spec_uses_convenience_method_with_name(resource,name='foo')
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "uses the #{resource} convenience method" do
            expect(chef_run.#{resource}('#{name}')).to_not be_nil
          end
        end
      }
    end

    def spec_expects_template_notifies_service
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "template 'foo' notifies resource 'bar'" do
            expect(chef_run.template('/etc/foo')).to notify('service[bar]', :restart)
          end
        end
      }
    end

    def spec_expects_template_notifies_service_having_braces_in_its_name
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "template 'foo' notifies resource 'bar'" do
            expect(chef_run.template('/etc/foo')).to notify('service[bar[v1.1]]',:restart)
          end
        end
      }
    end

    def spec_expects_include_recipe
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "template include another recipe it depends on" do
            expect(chef_run).to include_recipe('example::foo')
          end
        end
      }
    end
    def spec_expects_env_action(action)
      write_file 'cookbooks/example/spec/default_spec.rb', %Q{
        require "chefspec"

        describe "example::default" do
          let(:chef_run) { ChefSpec::ChefRunner.new.converge 'example::default' }
          it "#{action.to_s}s environment variable 'java_home'" do
            expect(chef_run).to #{action.to_s}_env('java_home')
          end
        end
      }
    end
  end
end
