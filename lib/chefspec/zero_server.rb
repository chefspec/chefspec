require 'chef_zero/server'

module ChefSpec
  # Rather than create a ChefZero instance per test case, simply create one
  # ChefZero instance and reset it for every test case.
  class ZeroServer
    class << self
      extend Forwardable
      def_delegators :instance, :setup!, :teardown!, :reset!, :upload_cookbooks!, :server, :load_data, :nuke!
    end

    include Singleton

    attr_reader :server

    # Create the ChefZero Server
    def initialize
      nuke!
    end

    #
    # Start the ChefZero Server
    #
    def setup!
      @server.start_background unless @server.running?
    end

    #
    # Remove all the data we just loaded from the ChefZero server
    #
    def reset!
      if RSpec.configuration.server_runner_clear_cookbooks
        @server.clear_data
        @cookbooks_uploaded = false
      else
        # If we don't want to do a full clear, iterate through each value that we
        # set and manually remove it.
        @data_loaded.each do |key, names|
          if key == "data"
            names.each { |n| @server.data_store.delete_dir(["organizations", "chef", key, n]) }
          else
            names.each { |n| @server.data_store.delete(["organizations", "chef", key, n]) }
          end
        end
      end
      @data_loaded = {}
    end

    #
    # Really reset everything and reload the configuration
    #
    def nuke!
      @server = ChefZero::Server.new(
        # Set the log level from RSpec, defaulting to warn
        log_level:  RSpec.configuration.log_level || :warn,
        port: RSpec.configuration.server_runner_port,

        # Set the data store
        data_store: data_store(RSpec.configuration.server_runner_data_store),
      )
      @cookbooks_uploaded = false
      @data_loaded = {}
    end

    #
    # Teardown the ChefZero Server
    #
    def teardown!
      @server.stop if @server.running?
    end

    #
    # Upload the cookbooks to the Chef Server.
    #
    def upload_cookbooks!
      return if @cookbooks_uploaded
      loader = Chef::CookbookLoader.new(Chef::Config[:cookbook_path])
      loader.load_cookbooks
      cookbook_uploader_for(loader).upload_cookbooks
      @cookbooks_uploaded = true
    end

    #
    # Load (and track) data sent to the server
    #
    # @param [String] name
    #   the name or id of the item to load
    # @param [String, Symbol] key
    #   the key to load
    # @param [Hash] data
    #   the data for the object, which will be converted to JSON and uploaded
    #   to the server
    #
    def load_data(name, key, data)
      @data_loaded[key] ||= []
      @data_loaded[key] << name
      @server.load_data({ key => { name => data } })
    end

    private

    #
    # The uploader for the cookbooks.
    #
    # @param [Chef::CookbookLoader] loader
    #   the Chef cookbook loader
    #
    # @return [Chef::CookbookUploader]
    #
    def cookbook_uploader_for(loader)
      Chef::CookbookUploader.new(loader.cookbooks)
    end

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
