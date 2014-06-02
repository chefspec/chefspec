begin
  require 'chef_zero/server'
rescue LoadError
  raise ChefSpec::Error::GemLoadError.new(gem: 'chef-zero', name: 'Chef Zero')
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

    #
    # RSpec 3 checks +respond_to?+ for some odd reason.
    #
    def self.respond_to_missing?(m, include_private = false)
      instance.respond_to?(m, include_private) || super
    end

    #
    # @macro entity
    #   @method create_$1(name, data = {})
    #     Create a new $1 on the Chef Server
    #
    #     @param [String] name
    #       the name of the $1
    #     @param [Hash] data
    #       the list of data to load
    #
    #
    #   @method $1(name)
    #     Find a $1 at the given name
    #
    #     @param [String] name
    #       the name of the $1
    #
    #     @return [$2, nil]
    #
    #
    #   @method $3
    #     The list of $1 on the Chef Server
    #
    #     @return [Array<Hash>]
    #       all the $1 on the Chef Server
    #
    #
    #   @method has_$1?(name)
    #     Determine if the Chef Server has the given $1
    #
    #     @param [String] name
    #       the name of the $1 to find
    #
    #     @return [Boolean]
    #
    def self.entity(method, klass, key)
      class_eval <<-EOH, __FILE__, __LINE__ + 1
        def create_#{method}(name, data = {})
          # Automatically set the "name" if no explicit one was given
          data[:name] ||= name

          # Convert it to JSON
          data = JSON.fast_generate(data)

          load_data(name, '#{key}', data)
        end

        def #{method}(name)
          data = get('#{key}', name)
          json = JSON.parse(data)

          if #{klass}.respond_to?(:json_create)
            #{klass}.json_create(json)
          else
            #{klass}.new(json)
          end
        rescue ChefZero::DataStore::DataNotFoundError
          nil
        end

        def #{key}
          get('#{key}')
        end

        def has_#{method}?(name)
          !get('#{key}', name).nil?
        rescue ChefZero::DataStore::DataNotFoundError
          false
        end
      EOH
    end

    entity :client,      Chef::Client, 'clients'
    entity :data_bag,    Chef::DataBag, 'data'
    entity :environment, Chef::Environment, 'environments'
    entity :node,        Chef::Node, 'nodes'
    entity :role,        Chef::Role, 'roles'

    include Singleton

    attr_reader :server

    #
    # Create a new instance of the +ChefSpec::Server+ singleton. This method
    # also starts the Chef Zero server in the background under the organization
    # "chefspec".
    #
    def initialize
      @server = ChefZero::Server.new(
        # Set the log level from RSpec, defaulting to warn
        log_level:  RSpec.configuration.log_level || :warn,

        # Set a random port so ChefSpec may be run in multiple jobs
        port: port,

        # Disable the "old" way - this is actually +multi_tenant: true+
        single_org: false,
      )
    end

    #
    # Create a new data_bag on the Chef Server. This overrides the method
    # created by {entity}
    #
    # @param [String] name
    #   the name of the data bag
    # @param [Hash] data
    #   the data to load into the data bag
    #
    def create_data_bag(name, data = {})
      load_data(name, 'data', data)
    end

    #
    # Create a new node on the Chef Server. This overrides the method created
    # by {entity}, permitting users to pass a raw +Chef::Node+ object in
    # addition to a hash.
    #
    # @example Create a node from a hash
    #
    #   create_node('bacon', attribute: 'value')
    #
    # @example Create a node from a +Chef::Node+ object
    #
    #   node = stub_node('bacon', platform: 'ubuntu', version: '12.04')
    #   create_node(node)
    #
    # @param [String, Chef::Node] object
    #   the object to create; this can be the name of the node, or an actual
    #   +Chef::Node+ object
    # @param [Hash] data
    #   the list of data to populate the node with; this is ignored if an
    #   actual node object is given
    #
    def create_node(object, data = {})
      if object.is_a?(Chef::Node)
        name = object.name
        data = object.to_json
      else
        name = object.to_s
        data[:name] ||= name
        data = JSON.fast_generate(data)
      end

      load_data(name, 'nodes', data)
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
    # The URL where ChefZero is listening (including the organization).
    #
    # @return [String]
    #
    def chef_server_url
      @chef_server_url ||= File.join(@server.url, 'organizations', organization)
    end

    #
    # Start the Chef Zero server in the background, updating the +Chef::Config+
    # with the proper +chef_server_url+.
    #
    def start!
      unless @server.running?
        @server.start_background
        Chef::Config[:chef_server_url] = chef_server_url
      end
    end

    #
    # Clear the contents of the server (used between examples)
    #
    def reset!
      @server.clear_data
      @server.data_store.create_dir(['organizations'], organization)
    end

    #
    # Stop the Chef Zero server, if it is running. This method also runs any
    # cleanup hooks, such as clearing the cache directories.
    #
    def stop!
      @server.stop if @server.running?
      FileUtils.rm_rf(cache_dir)
    end

    private

    #
    # The name of the Chef organization.
    #
    # @return [String]
    #
    def organization
      RSpec.configuration.organization
    end

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
    # @param [String] name
    #   the name or id of the item to load
    # @param [String, Symbol] key
    #   the key to load
    # @param [Hash] data
    #   the data for the object, which will be converted to JSON and uploaded
    #   to the server
    #
    def load_data(name, key, data = {})
      @server.load_data({ key => { name => data } }, organization)
    end

    #
    # Get the path to an item in the data store.
    #
    def get(*args)
      if args.size == 1
        @server.data_store.list(with_organization(*args))
      else
        @server.data_store.get(with_organization(*args))
      end
    end

    #
    # Prefix the given args with the organization. This is used by the data
    # store to fetch elements.
    #
    # @return [Array<String>]
    #
    def with_organization(*args)
      ['organizations', organization, *args]
    end

    #
    # A randomly assigned, open port for run the Chef Zero server.
    #
    # @return [Fixnum]
    #
    def port
      return @port if @port

      @server = TCPServer.new('127.0.0.1', 0)
      @port   = @server.addr[1].to_i
      @server.close

      return @port
    end
  end
end

ChefSpec::Server.start!

RSpec.configure do |config|
  config.before(:each) { ChefSpec::Server.reset! }
  config.after(:each)  { ChefSpec::Server.reset! }
end

at_exit { ChefSpec::Server.stop! }
