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

          create_specs(Array(config[:cookbook_path]).first, @name_args.first)
        end

        private

        # Has a default cookbook path been set?
        #
        # @return [Boolean] True if cookbook path has been set in the Chef config.
        def default_cookbook_path_empty?
          Chef::Config[:cookbook_path].nil? || Chef::Config[:cookbook_path].empty?
        end

        # Create placeholder specs for the cookbook.
        #
        # @param [String] dir The directory to create the specs in
        # @param [String] cookbook The name of the cookbook
        # @param [String] recipe The name of the recipe to create a spec for
        def create_specs(dir, cookbook)
          spec_dir = "#{File.join(dir, cookbook, 'spec')}"
          FileUtils.mkdir_p spec_dir
          msg("** Creating specs for cookbook: #{cookbook}")
          existing_recipes(dir, cookbook).each do |recipe|
            create_spec(spec_dir, cookbook, recipe)
          end
        end

        # The list of recipes for a cookbook
        #
        # @param [String] dir The directory
        # @param [String] cookbook The name of the cookbook
        # @return [Array] The list of recipes for the cookbook
        def existing_recipes(dir, cookbook)
          Dir[File.join(dir, cookbook, 'recipes/*.rb')].map{|recipe| File.basename recipe, '.rb'}
        end

        # Create a placeholder spec for the cookbook.
        #
        # @param [String] spec_dir The directory to create the specs in
        # @param [String] cookbook The name of the cookbook
        # @param [String] recipe The name of the recipe to create a spec for
        def create_spec(spec_dir, cookbook, recipe)
          unless File.exists?(File.join(spec_dir, "#{recipe}_spec.rb"))
            open(File.join(spec_dir, "#{recipe}_spec.rb"), "w") do |file|
              file.puts spec_file_content(cookbook, recipe)
            end
          end
        end

        # Generate the content for the placeholder spec file.
        #
        # @param [String] cookbook The name of the cookbook
        # @param [String] recipe The name of the recipe
        def spec_file_content(cookbook, recipe)
          return <<-EOH
require 'chefspec'

describe '#{cookbook}::#{recipe}' do
  let (:chef_run) { ChefSpec::ChefRunner.new.converge '#{cookbook}::#{recipe}' }
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
