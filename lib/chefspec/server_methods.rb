module ChefSpec
  # This module contains the list of methods that are specific to creating and
  # managing resources within an Chef Zero instance. It is designed to be
  # included in a class which exposes a `server` instance variable or method
  # that returns a {ChefZero::Server} instance.
  module ServerMethods
    #
    # The actual Chef Zero Server object.
    #
    # @return [ChefZero::Server]
    #
    def server
      ChefSpec::ZeroServer.server
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
    #     @return [true, false]
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

        def get_#{method}(name)
          data = get('#{key}', name)
          json = JSON.parse(data)

          case
          when #{klass}.respond_to?(:json_create)
            #{klass}.json_create(json)
          when #{klass}.respond_to?(:from_hash)
            #{klass}.from_hash(json)
          else
            #{klass}.new(json)
          end
        rescue ChefZero::DataStore::DataNotFoundError
          nil
        end

        def get_#{key}
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
    #   node = stub_node('bacon', platform: 'ubuntu', version: '16.04')
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
    alias_method :update_node, :create_node

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
      ChefSpec::ZeroServer.load_data(name, key, data)
    end

    #
    # Get the path to an item in the data store.
    #
    def get(*args)
      args.unshift('organizations', 'chef')

      if args.size == 3
        server.data_store.list(args)
      else
        server.data_store.get(args)
      end
    end
  end
end
