module ChefSpec
  module ExampleHelpers

    def assert_cookbook_created(cookbook_name)
      assert_partial_output "Creating cookbook #{cookbook_name}", all_output
      check_directory_presence [cookbook_name], true
      check_file_presence ["my_new_cookbook/recipes/default.rb"], true
    end

    def assert_example_generator_command_exists
      assert_partial_output 'knife cookbook create_specs COOKBOOK (options)', all_output
    end

    def assert_no_example_generated
      check_directory_presence ['my_new_cookbook/spec'], false
      check_file_presence ['my_new_cookbook/spec/default_spec.rb'], false
    end

    def command_not_executed
      assert_no_partial_output 'Hello World!', all_output
    end

    def cookbook_with_four_recipes
      ['default', 'chicken_tikka_masala', 'fish_and_chips', 'yorkshire_pudding'].each do |recipe|
        write_file "my_existing_cookbook/recipes/#{recipe}.rb", %Q{
          execute "prepare_#{recipe}" do
            command "echo Here is one I prepared earlier!"
            action :run
          end
        }
      end
    end

    def cookbook_with_lwrp
      write_file 'cookbooks/example/resources/default.rb', %Q{
        actions :greet
        attribute :name, :kind_of => String, :name_attribute => true
      }
      write_file 'cookbooks/example/providers/default.rb', %q{
        action :greet do
          execute "hello" do
            command "echo Hello #{new_resource.name}!"
            action :run
          end
        end
      }
      write_file 'cookbooks/example/recipes/default.rb', %Q{
        example "Foobar" do
          action :greet
        end
      }
    end

    def ensure_knife_is_present
      run_simple 'knife -v'
      assert_success(true)
    end

    def knife_cookbook_commands
      run_simple 'knife cookbook --help', false
    end

    def recipe_creates_directory
      write_file 'cookbooks/example/recipes/default.rb', %q{
        directory "foo" do
          action :create
        end
      }
    end

    def recipe_deletes_directory
      write_file 'cookbooks/example/recipes/default.rb', %q{
        directory "foo" do
          action :delete
        end
      }
      create_dir 'foo'
    end

    def recipe_deletes_file
      write_file 'cookbooks/example/recipes/default.rb', %q{
        file "hello-world.txt" do
          content "hello world"
          action :delete
        end
      }
      write_file 'hello-world.txt', 'Hello world!'
    end

    def recipe_executes_command
      write_file 'cookbooks/example/recipes/default.rb', %q{
        execute "print_hello_world" do
          command "echo Hello World!"
          action :run
        end
      }
    end

    def recipe_installs_gem
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist" do
          action :install
        end
      }
    end

    def recipe_installs_package
      write_file 'cookbooks/example/recipes/default.rb', %q{
        package "package_does_not_exist" do
          action :install
        end
      }
    end

    def recipe_installs_package_with_no_action
      write_file "cookbooks/example/recipes/default.rb", %q{
        package "package_does_not_exist"
      }
    end

    def recipe_installs_specific_gem_version
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist" do
          version "1.2.3"
          action :install
        end
      }
    end

    def recipe_installs_specific_package_version
      write_file "cookbooks/example/recipes/default.rb", %q{
        package "package_does_not_exist" do
          version "1.2.3"
          action :install
        end
      }
    end

    def recipe_installs_specific_gem_version_with_no_action
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist" do
          version "1.2.3"
        end
      }
    end

    def recipe_installs_specific_package_version_with_no_action
      write_file 'cookbooks/example/recipes/default.rb', %q{
        package "package_does_not_exist" do
          version "1.2.3"
        end
      }
    end

    def recipe_logs_node_attribute
      write_file 'cookbooks/example/recipes/default.rb', %q{
        log "The value of node.foo is: #{node.foo}"
      }
    end

    def recipe_purges_gem
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist" do
          action :purge
        end
      }
    end

    def recipe_purges_package
      write_file "cookbooks/example/recipes/default.rb", %q{
        package "package_does_not_exist" do
          action :purge
        end
      }
    end

    def recipe_renders_template(options)
      options = {:missing => false, :another_cookbook => false}.merge(options)
      template_name = options[:missing] ? 'wrong_name.erb' : 'config_file.erb'
      template_cookbook = options[:another_cookbook] ? 'another' : 'example'
      write_file 'cookbooks/example/recipes/default.rb', %Q{
        template "/etc/config_file" do
          action :create
          variables({:platform => node[:platform]})
          #{'cookbook "another"' if options[:another_cookbook]}
        end
      }
      write_file "cookbooks/#{template_cookbook}/templates/default/#{template_name}", %q{
        # Config file generated by Chef
        platform: <%= @platform %>
      }.gsub(/^\s+/, '')
    end

    def recipe_removes_gem
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist" do
          action :remove
        end
      }
    end

    def recipe_removes_package
      write_file "cookbooks/example/recipes/default.rb", %q{
        package "package_does_not_exist" do
          action :remove
        end
      }
    end

    def recipe_reloads_service
      write_file 'cookbooks/example/recipes/default.rb', %q{
        service "food" do
          action :reload
        end
      }
    end

    def recipe_restarts_service
      write_file 'cookbooks/example/recipes/default.rb', %q{
        service "food" do
          action :restart
        end
      }
    end

    def recipe_starts_service
      write_file 'cookbooks/example/recipes/default.rb', %q{
        service "food" do
          action :start
        end
      }
    end

    def recipe_starts_and_enables_service
      write_file 'cookbooks/example/recipes/default.rb', %q{
        service "food" do
          action [:enable, :start]
        end
      }
    end

    def recipe_stops_service
      write_file 'cookbooks/example/recipes/default.rb', %q{
        service "food" do
          action :stop
        end
      }
    end

    def recipe_upgrades_package
      write_file "cookbooks/example/recipes/default.rb", %q{
        package "package_does_not_exist" do
          action :upgrade
        end
      }
    end

    def recipe_sees_correct_attribute_value
      assert_partial_output 'Processing log[The value of node.foo is: bar]', all_output
    end

    def recipe_sees_correct_operating_system
      assert_partial_output "Processing log[I am running on the #{@operating_system} platform.]", all_output
    end

    def recipe_sets_directory_ownership
      write_file 'cookbooks/example/recipes/default.rb', %q{
        directory "foo" do
          owner "user"
          group "group"
        end
      }
      create_dir 'foo'
      @original_stat = owner_and_group 'foo'
    end

    def recipe_sets_file_ownership(resource_type)
      write_file 'hello-world.txt', 'hello world!'
      write_file 'cookbooks/example/recipes/default.rb', %Q{
        #{resource_type.to_s} "hello-world.txt" do
          owner "user"
          group "group"
        end
      }
      @original_stat = owner_and_group 'hello-world.txt'
    end

    def recipe_switches_on_operating_system
      write_file 'cookbooks/example/recipes/default.rb', %q{
        case node.platform
          when "leprechaun", "sprite", "balloon"
            log("I am running on the #{node.platform} platform.")
          else
            log("This recipe is only supported on Leprechaun flavoured distros at this time.") { level :error }
        end
      }
    end

    def recipe_upgrades_gem
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist" do
          action :upgrade
        end
      }
    end

    def recipe_with_cookbook_file
      write_file 'cookbooks/example/files/default/hello-world.txt', 'hello world!'
      write_file 'cookbooks/example/recipes/default.rb', 'cookbook_file "hello-world.txt"'
    end

    def recipe_with_file(file_content = 'hello world!')
      write_file 'cookbooks/example/recipes/default.rb', %Q{
        file "hello-world.txt" do
          content "#{file_content}"
          action :create
        end
      }
    end

    def recipe_with_gem_no_action
      write_file 'cookbooks/example/recipes/default.rb', %q{
        gem_package "gem_package_does_not_exist"
      }
    end

    def recipe_with_remote_file
      write_file 'cookbooks/example/recipes/default.rb', %q{
        remote_file "hello-world.txt" do
          action :create
        end
      }
    end

    def recipe_creates_user
      write_file 'cookbooks/example/recipes/default.rb', %q{
        user "foo" do
          action :create
        end
      }
    end

    def recipe_removes_user
      write_file 'cookbooks/example/recipes/default.rb', %q{
        user "foo" do
          action :remove
        end
      }
    end

  end
end
World(ChefSpec::ExampleHelpers)
