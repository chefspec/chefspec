begin
  require 'librarian/chef/environment'
  require 'librarian/action/resolve'
  require 'librarian/action/install'
rescue LoadError
  raise RuntimeError, "Librarian not found! You must have the librarian-chef" \
    " gem installed on your system before requiring chefspec/librarian." \
    " Install it by running:\n\n  gem install librarian-chef\n\nor add" \
    " Librarian to your Gemfile:\n\n  gem 'librarian-chef'\n\n"
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
      env = ::Librarian::Chef::Environment.new(:project_path => Dir.pwd)
      env.config_db.local["path"] = @tmpdir
      ::Librarian::Action::Resolve.new(env).run
      ::Librarian::Action::Install.new(env).run

      ::RSpec.configure { |config| config.cookbook_path = @tmpdir }
    end

    #
    # Remove the temporary directory.
    #
    def teardown!
      FileUtils.rm_rf(@tmpdir) if File.exists?(@tmpdir)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { ChefSpec::Librarian.setup! }
  config.after(:suite)  { ChefSpec::Librarian.teardown! }
end
