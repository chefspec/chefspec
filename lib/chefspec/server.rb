begin
  require 'chef_zero/server'
rescue LoadError
  raise RuntimeError, "chef-zero not found! You must have the chef-zero gem" \
    " installed on your system before requiring chefspec/server. Install" \
    " Chef Zero by running:\n\n  gem install chef-zero\n\nor add Chef Zero" \
    " to your Gemfile:\n\n  gem 'chef-zero'\n\n"
end

require 'chef/cookbook_loader'
require 'chef/cookbook_uploader'

class Chef::CookbookUploader
  #
  # Don't validate uploaded cookbooks. Validating a cookbook takes *forever*
  # to complete. It's just not worth it...
  #
  def validate_cookbooks
    # noop
  end
end

class ChefSpec::Runner
  alias_method :old_initialize, :initialize

  #
  # Override the existing initialize method, setting the appropriate
  # configuration to use a real Chef Server instead.
  #
  # @see ChefSpec::Runner#initialize
  #
  def initialize(options = {}, &block)
    old_initialize(options, &block)

    Chef::Config[:client_key]      = ChefSpec::Server.client_key
    Chef::Config[:client_name]     = 'chefspec'
    Chef::Config[:node_name]       = 'chefspec'
    Chef::Config[:file_cache_path] = Dir.mktmpdir
    Chef::Config[:solo]            = false

    upload_cookbooks!
  end

  private

    #
    # Upload the cookbooks to the Chef Server.
    #
    def upload_cookbooks!
      loader = Chef::CookbookLoader.new(Chef::Config[:cookbook_path])
      loader.load_cookbooks

      uploader = Chef::CookbookUploader.new(loader.cookbooks, loader.cookbook_paths)
      uploader.upload_cookbooks
    end
end

module ChefSpec
  class Server
    #
    # Delegate all methods to the singleton instance.
    #
    def self.method_missing(m, *args, &block)
      instance.send(m, *args, &block)
    end

    include Singleton

    attr_reader :server

    #
    # Create a new instance of the +ChefSpec::Server+ singleton. This method
    # also starts the Chef Zero server in the background.
    #
    def initialize
      @server = ChefZero::Server.new(
        log_level:  RSpec.configuration.log_level || :warn,
      )
    end

    #
    # The path to the insecure Chef Zero private key on disk. Because Chef
    # requires the path to a file instead of the contents of the key (why),
    # this method dynamically writes the +ChefZero::PRIVATE_KEY+ to disk and
    # then returns that path.
    #
    # @return [String]
    #   the path to the client key on disk
    #
    def client_key
      @client_key ||= begin
        path = File.join(cache_dir, 'client.pem')
        File.open(path, 'w') { |f| f.write(ChefZero::PRIVATE_KEY) }
        path
      end
    end

    #
    # Start the Chef Zero server in the background, updating the +Chef::Config+
    # with the proper +chef_server_url+.
    #
    def start!
      unless @server.running?
        @server.start_background
        Chef::Config[:chef_server_url] = @server.url
      end
    end

    #
    # Clear the contents of the server (used between examples)
    #
    def reset!
      @server.clear_data
    end

    #
    # Stop the Chef Zero server, if it is running. This method also runs any
    # cleanup hooks, such as clearing the cache directories.
    #
    def stop!
      @server.stop if @server.running?
      FileUtils.rm_rf(cache_dir)
    end

    #
    # Create a client on the Chef Server.
    #
    def create_client(name, data = {})
      load_data(:clients, name, data)
    end

    #
    # Create a data_bag on the Chef Server.
    #
    def create_data_bag(name, data = {})
      @server.load_data('data' => { name => data })
    end

    #
    # Create an environment on the Chef Server.
    #
    def create_environment(name, data = {})
      load_data(:environments, name, data)
    end

    #
    # Create a node on the Chef Server.
    #
    # @note
    #   The current node (chefspec) is automatically registered and added to
    #   the Chef Server
    #
    def create_node(name, data = {})
      load_data(:nodes, name, data)
    end

    #
    # Create a role on the Chef Server.
    #
    def create_role(name, data = {})
      load_data(:roles, name, data)
    end

    private

      #
      # The directory where any cache information (such as private keys) should
      # be stored. This cache is destroyed at the end of the run.
      #
      # @return [String]
      #   the path to the cache directory on disk
      #
      def cache_dir
        @cache_dir ||= Dir.mktmpdir(['chefspec', 'cache'])
      end

      #
      # Shortcut method for loading data into Chef Zero.
      #
      # @param [String, Symbol] key
      #   the key to load
      # @param [String] name
      #   the name or id of the item to load
      # @param [Hash] data
      #   the data for the object, which will be converted to JSON and uploaded
      #   to the server
      #
      def load_data(key, name, data = {})
        @server.load_data(key.to_s => { name => JSON.fast_generate(data) })
      end
  end
end

ChefSpec::Server.start!

RSpec.configure do |config|
  config.after(:each)   { ChefSpec::Server.reset! }
end

at_exit { ChefSpec::Server.stop! }
