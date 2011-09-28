require 'chefspec'

if Chef.const_defined? :Knife
  module ChefSpec
    module Knife

      # Knife plugin to create placeholder specs.
      #
      # $ knife cookbook create -o . my_new_cookbook
      # $ knife cookbook create_specs -o . my_new_cookbook
      # $ rspec my_new_cookbook
      #
      # http://help.opscode.com/kb/knife/manage-cookbooks-with-knife
      class CookbookCreateSpecs < Chef::Knife

        # Implemented as a separate knife command rather than extending the knife built-in create_cookbook_command.
        # Extension may arguably have been better from the end user perspective but would be much more brittle.

        banner "knife cookbook create_specs COOKBOOK (options)"

        option :cookbook_path,
               :short => "-o PATH",
               :long => "--cookbook-path PATH",
               :description => "The directory where the cookbook specs will be created"

        # Invoke this command and create the new specs
        def run
          self.config = Chef::Config.merge!(config)
          if @name_args.empty?
            show_usage
            ui.fatal("You must specify a cookbook name")
            exit 1
          end

          if default_cookbook_path_empty? && parameter_empty?(config[:cookbook_path])
            raise ArgumentError, "Default cookbook_path is not specified in the knife.rb config file, and a value to -o is not provided. Nowhere to write the new cookbook to."
          end

          create_spec(Array(config[:cookbook_path]).first, @name_args.first)
        end

        private

        # Has a default cookbook path been set?
        #
        # @return [Boolean] True if cookbook path has been set in the Chef config.
        def default_cookbook_path_empty?
          Chef::Config[:cookbook_path].nil? || Chef::Config[:cookbook_path].empty?
        end

        # Create a placeholder spec for the new cookbook.
        #
        # @param [String] dir The directory to create the cookbook in
        # @param [String] cookbook_name The name of the cookbook
        def create_spec(dir, cookbook_name)
          spec_dir = "#{File.join(dir, cookbook_name, 'spec')}"
          FileUtils.mkdir_p spec_dir
          msg("** Creating spec for cookbook: #{cookbook_name}")
          unless File.exists?(File.join(spec_dir, "default_spec.rb"))
            open(File.join(spec_dir, "default_spec.rb"), "w") do |file|
              file.puts spec_file_content(cookbook_name)
            end
          end
        end

        # Generate the content for the placeholder spec file.
        #
        # @param [String] cookbook_name The name of the cookbook
        def spec_file_content(cookbook_name)
          return <<-EOH
require 'chefspec'

describe '#{cookbook_name}::default' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge '#{cookbook_name}::default' }
  it 'should do something' do
    pending 'Your recipe examples go here.'
  end
end
          EOH
        end

      end
    end
  end
end
