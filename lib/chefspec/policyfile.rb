begin
  require 'chef-dk/policyfile_services/export_repo'
  require 'chef-dk/policyfile_services/install'
  require 'chef-dk/configurable'
rescue LoadError
  raise ChefSpec::Error::GemLoadError.new(gem: 'chef-dk', name: 'ChefDK')
end

module ChefSpec
  class Policyfile
    class << self
      extend Forwardable
      def_delegators :instance, :setup!, :teardown!
    end

    include Singleton
    include ChefDK::Configurable

    def initialize
      @tmpdir = Dir.mktmpdir
    end

    #
    # Setup and install the necessary  dependencies in the temporary directory
    #
    def setup!
      policyfile_path = File.join(Dir.pwd, 'Policyfile.rb')

      installer = ChefDK::PolicyfileServices::Install.new(
        policyfile: policyfile_path,
        ui: ChefDK::UI.null,
        config: chef_config
      )

      installer.run

      exporter = ChefDK::PolicyfileServices::ExportRepo.new(
        policyfile: policyfile_path,
        export_dir: @tmpdir
      )

      FileUtils.rm_rf(@tmpdir)
      exporter.run

      ::RSpec.configure do |config|
        config.cookbook_path = [
          File.join(@tmpdir, 'cookbooks'),
          File.join(@tmpdir, 'cookbook_artifacts')
        ]
      end
    end

    #
    # Remove the temporary directory
    #
    def teardown!
      FileUtils.rm_rf(@tmpdir) if File.exist?(@tmpdir)
    end

    private

    # chef_config calls this method to retrieve the path to the config file
    # See ChefDK::Configurable#config_loader
    def config
      {
        config_file: Chef::WorkstationConfigLoader.new(nil).config_location,
      }
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { ChefSpec::Policyfile.setup! }
  config.after(:suite)  { ChefSpec::Policyfile.teardown! }
end
