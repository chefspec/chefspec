require 'chef_zero/server'

module ChefSpec
  # Rather than create a ChefZero instance per test case, simply create one
  # ChefZero instance and reset it for every test case.
  class ZeroServer
    class << self
      extend Forwardable
      def_delegators :instance, :setup!, :teardown!, :reset!, :server
    end

    include Singleton

    # Create the ChefZero Server
    def initialize
      @server ||= ChefZero::Server.new(
        # Set the log level from RSpec, defaulting to warn
        log_level:  RSpec.configuration.log_level || :warn,

        # Set the data store
        data_store: data_store(RSpec.configuration.server_runner_data_store),
      )
    end

    # Start the ChefZero Server
    def setup!
      @server.start_background
    end

    # Remove all the non-cookbook entities from the ChefZero Server
    def reset!
      @server.clear_data
    end

    # Teardown the ChefZero Server
    def teardown!
      @server.stop if @server.running?
    end

    # The URL for the ChefZero Server
    def server
      @server
    end

    private

    #
    # Generate the DataStore object to be passed in to the ChefZero::Server object
    #
    def data_store(option)
      require "chef_zero/data_store/default_facade"

      store = case option
              when :in_memory
                require "chef_zero/data_store/memory_store_v2"
                ChefZero::DataStore::MemoryStoreV2.new
              when :on_disk
                require "tmpdir"
                require "chef_zero/data_store/raw_file_store"
                tmpdir = Dir.mktmpdir
                ChefZero::DataStore::RawFileStore.new(Dir.mktmpdir)
              else
                raise ArgumentError, ":#{option} is not a valid server_runner_data_store option. Please use either :in_memory or :on_disk."
              end

      ChefZero::DataStore::DefaultFacade.new(store, "chef", true)
    end
  end
end

RSpec.configure do |config|
  config.before(:suite) { ChefSpec::ZeroServer.setup! }
  config.after(:each) { ChefSpec::ZeroServer.reset! }
  config.after(:suite)  { ChefSpec::ZeroServer.teardown! }
end
