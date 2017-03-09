module ChefSpec
  module Macros
    extend self

    #
    # The name of the currently running cookbook spec. Given the top-level
    # +describe+ block is of the format:
    #
    #     describe 'my_cookbook::my_recipe' do
    #       # ...
    #     end
    #
    # The value of +described_cookbook+ is "my_cookbook".
    #
    # @example Using +described_cookbook+ in a context block
    #   context "#{described_recipe} installs foo" do
    #     # ...
    #   end
    #
    #
    # @return [String]
    #
    def described_cookbook
      described_recipe.split('::').first
    end

    #
    # The name of the currently running recipe spec. Given the top-level
    # +describe+ block is of the format:
    #
    #     describe 'my_cookbook::my_recipe' do
    #       # ...
    #     end
    #
    # The value of +described_recipe+ is "my_cookbook::my_recipe".
    #
    # @example Using +described_recipe+ in the +ChefSpec::SoloRunner+
    #   let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
    #
    #
    # @return [String]
    #
    def described_recipe
      scope = self.is_a?(Class) ? self : self.class

      metahash = scope.metadata
      while metahash.has_key?(:parent_example_group)
        metahash = metahash[:parent_example_group]
      end

      metahash[:description].to_s
    end

    #
    # Stub a shell command to return a particular value without
    # shelling out to the system.
    #
    # @example stubbing a command to return true
    #   stub_command('test -f /tmp/bacon').and_return(true)
    #
    # @example stubbing a block that is evaluated at runtime
    #   stub_command('test -f /tmp/bacon') { MyClass.check? }
    #
    # @example stubbing a command that matches a pattern
    #   stub_command(/test \-f/).and_return(true)
    #
    # @example stubbing a command that raises an exception
    #   stub_command('test -f /tmp/bacon').and_raise(SomeException)
    #
    #
    # @param [String, Regexp] command
    #   the command to stub
    #
    # @return [ChefSpec::CommandStub]
    #
    def stub_command(command, &block)
      Stubs::CommandRegistry.register(Stubs::CommandStub.new(command, &block))
    end

    #
    # Stub a Chef call to load a data_bag.
    #
    # @example stubbing a data_bag to return an empty Array
    #   stub_data_bag('users').and_return([])
    #
    # @example stubbing a data_bag with a block that is evaluated at runtime
    #   stub_data_bag('users') { JSON.parse(File.read('fixtures/data_bag.json')) }
    #
    # @example stubbing a data_bag to return an Array of Hashes
    #   stub_data_bag('users').and_return([
    #     { id: 'bacon', comment: 'delicious' },
    #     { id: 'ham', comment: 'also good' }
    #   ])
    #
    # @example stubbing a data_bag to raise an exception
    #   stub_data_bag('users').and_raise(Chef::Exceptions::PrivateKeyMissing)
    #
    #
    # @param [String, Symbol] bag
    #   the name of the data bag to stub
    #
    # @return [ChefSpec::DataBagStub]
    #
    def stub_data_bag(bag, &block)
      Stubs::DataBagRegistry.register(Stubs::DataBagStub.new(bag, &block))
    end

    #
    # Stub a Chef data_bag call.
    #
    # @example stubbing a data_bag_item to return a Hash of data
    #   stub_data_bag_item('users', 'svargo').and_return({
    #     id: 'svargo',
    #     name: 'Seth Vargo'
    #   })
    #
    # @example stubbing a data_bag_item with a block that is evaluated at runtime
    #   stub_data_bag_item('users', 'svargo') { JSON.parse(File.read('fixtures/data_bag_item.json')) }
    #
    # @example stubbing a data_bag_item to raise an exception
    #   stub_data_bag('users', 'svargo').and_raise(Chef::Exceptions::PrivateKeyMissing)
    #
    #
    # @param [String, Symbol] bag
    #   the name of the data bag to find the item in
    # @param [String] id
    #   the id of the data bag item to stub
    #
    # @return [ChefSpec::DataBagItemStub]
    #
    def stub_data_bag_item(bag, id, &block)
      Stubs::DataBagItemRegistry.register(Stubs::DataBagItemStub.new(bag, id, &block))
    end

    #
    # Creates a fake Chef::Node for use in testing.
    #
    # @example mocking a simple node
    #   stub_node('mynode.example')
    #
    # @example mocking a specific platform and version
    #   stub_node('mynode.example', platform: 'ubuntu', version: '16.04')
    #
    # @example overriding a specific ohai attribute
    #   stub_node('mynode.example', ohai: { ipaddress: '1.2.3.4' })
    #
    # @example stubbing a node based on a JSON fixture
    #   stub_node('mynode.example', path: File.join('fixtures', 'nodes', 'default.json'))
    #
    # @example setting specific attributes
    #   stub_node('mynode.example') do |node|
    #     node.default['attribute']['thing'] = 'value'
    #   end
    #
    #
    # @param [String] name
    #   the name of the node
    # @param [Hash] options
    #   the list of options for the node
    #
    # @option options [Symbol] :platform
    #   the platform to mock
    # @option options [Symbol] :version
    #   the version of the platform to mock
    # @option options [Symbol] :path
    #   filepath to a JSON file to pull a node from
    # @option options [Hash] :ohai
    #   a Hash of Ohai attributes to mock on the node
    #
    # @return [Chef::Node]
    #
    def stub_node(*args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      name    = args.first || 'node.example'

      fauxhai = Fauxhai.mock(options).data
      fauxhai = fauxhai.merge(options[:ohai] || {})
      fauxhai = Mash.new(fauxhai)

      node = Chef::Node.new
      node.name(name)
      node.automatic_attrs = fauxhai
      node.instance_eval(&block) if block_given?
      node
    end

    #
    # Stub a Chef search to return pre-defined data. When providing a value,
    # the value is automatically mashified (to the best of ChefSpec's abilities)
    # to ease in use.
    #
    # @example stubbing a search to return nothing
    #   stub_search(:node)
    #
    # @example stubbing a search with a query
    #   stub_search(:node, 'name:*')
    #
    # @example stubbing a search with a query as a regex
    #   stub_search(:node, /name:(.+)/)
    #
    # @example stubbing a search with a block that is evaluated at runtime
    #   stub_search(:node) { JSON.parse(File.read('fixtures/nodes.json')) }
    #
    # @example stubbing a search to return a fixed value
    #   stub_search(:node).and_return([ { a: 'b' } ])
    #
    # @example stubbing a search to raise an exception
    #   stub_search(:node).and_raise(Chef::Exceptions::PrivateKeyMissing)
    #
    #
    # @param [String, Symbol] type
    #   the type to search to stub
    # @param [String, Symbol, nil] query
    #   the query to stub
    #
    # @return [ChefSpec::SearchStub]
    #
    def stub_search(type, query = '*:*', &block)
      Stubs::SearchRegistry.register(Stubs::SearchStub.new(type, query, &block))
    end
  end
end
