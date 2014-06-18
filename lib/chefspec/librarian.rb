begin
  require 'librarian/chef/environment'
  require 'librarian/action/resolve'
  require 'librarian/action/install'
rescue LoadError
  raise ChefSpec::Error::GemLoadError.new(
    gem: 'librarian-chef', name: 'Librarian')
end

module ChefSpec
  class Librarian
    class << self
      extend Forwardable
      def_delegators :instance, :setup!, :teardown!
    end

    include Singleton

    def initialize
      @tmpdir = Dir.mktmpdir
    end

    #
    # Setup and install the necessary dependencies in the temporary directory.
    #
    def setup!
      env = ::Librarian::Chef::Environment.new(project_path: Dir.pwd)
      @originalpath, env.config_db.local['path'] = env.config_db.local['path'], @tmpdir
      ::Librarian::Action::Resolve.new(env).run
      ::Librarian::Action::Install.new(env).run

      ::RSpec.configure { |config| config.cookbook_path = @tmpdir }
    end

    #
    # Remove the temporary directory and restore the librarian-chef cookbook path.
    #
    def teardown!
      env = ::Librarian::Chef::Environment.new(project_path: Dir.pwd)
      env.config_db.local['path'] = @originalpath

      FileUtils.rm_rf(@tmpdir) if File.exist?(@tmpdir)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { ChefSpec::Librarian.setup! }
  config.after(:suite)  { ChefSpec::Librarian.teardown! }
end
