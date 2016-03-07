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

    include Singleton

    def initialize
      @tmpdir = Dir.mktmpdir
    end

    #
    # Setup and install the necessary dependencies in the temporary directory.
    #
    def setup!
      # Get the list of Berkshelf options
      opts = RSpec.configuration.berkshelf_options
      if !opts.is_a?(Hash)
        raise InvalidBerkshelfOptions(value: opts.inspect)
      end

      berksfile = ::Berkshelf::Berksfile.from_file('Berksfile', opts)

      # Grab a handle to tmpdir, since Berkshelf 2 modifies it a bit
      tmpdir = File.join(@tmpdir, 'cookbooks')

      ::Berkshelf.ui.mute do
        if ::Berkshelf::Berksfile.method_defined?(:vendor)
          # Berkshelf 3.0 requires the directory to not exist
          FileUtils.rm_rf(tmpdir)
          berksfile.vendor(tmpdir)
        else
          berksfile.install(path: tmpdir)
        end
      end

      filter = Coverage::BerkshelfFilter.new(berksfile)
      Coverage.add_filter(filter)

      ::RSpec.configure { |config| config.cookbook_path = tmpdir }
    end

    #
    # Destroy the installed Berkshelf at the temporary directory.
    #
    def teardown!
      FileUtils.rm_rf(@tmpdir) if File.exist?(@tmpdir)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { ChefSpec::Berkshelf.setup! }
  config.after(:suite)  { ChefSpec::Berkshelf.teardown! }
end
