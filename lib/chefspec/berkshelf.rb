begin
  require 'berkshelf'
rescue LoadError
  raise ChefSpec::Error::GemLoadError.new(gem: 'berkshelf', name: 'Berkshelf')
end

module ChefSpec
  class Berkshelf
    class << self
      extend Forwardable
      def_delegators :instance, :setup!, :teardown!
    end

    attr_reader :tmpdir

    include Singleton

    def initialize
      @tmpdir = Dir.mktmpdir
    end

    #
    # Setup and install the necessary dependencies in the temporary directory.
    #
    def setup!
      ::Berkshelf.ui.mute do
        if ::Berkshelf::Berksfile.method_defined?(:vendor)
          FileUtils.rm_rf(@tmpdir) # Berkshelf 3.0 requires the directory to not exist
          ::Berkshelf::Berksfile.from_file('Berksfile').vendor(@tmpdir)
        else
          ::Berkshelf::Berksfile.from_file('Berksfile').install(path: @tmpdir)
        end
      end

      ::RSpec.configure { |config| config.cookbook_path = @tmpdir }
    end

    #
    # Destroy the installed Berkshelf at the temporary directory.
    #
    def teardown!
      FileUtils.rm_rf(@tmpdir) if File.exists?(@tmpdir)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { ChefSpec::Berkshelf.setup! }
  config.after(:suite)  { ChefSpec::Berkshelf.teardown! }
end
