require 'chef/dsl/data_query'

Chef::DSL::DataQuery.prepend(Module.new do
  # @see Chef::DSL::DataQuery#search
  def search(*args, &block)
    return super unless Chef::Config[:solo] && $CHEFSPEC_MODE

    type  = args[0]
    query = args[1] || '*:*'
    stub = ChefSpec::Stubs::SearchRegistry.stub_for(type, query)

    if stub.nil?
      raise ChefSpec::Error::SearchNotStubbed.new(args: [type, query])
    end

    if block
      Array(stub.result).each {|r| block.call(r) }
      true
    else
      stub.result
    end
  end

  # @see Chef::DSL::DataQuery#data_bag
  def data_bag(bag)
    return super unless Chef::Config[:solo] && $CHEFSPEC_MODE

    stub = ChefSpec::Stubs::DataBagRegistry.stub_for(bag)

    if stub.nil?
      raise ChefSpec::Error::DataBagNotStubbed.new(args: [bag])
    end

    stub.result
  end

  # @see Chef::DSL::DataQuery#data_bag_item
  def data_bag_item(bag, id, secret = nil)
    return super unless Chef::Config[:solo] && $CHEFSPEC_MODE

    stub = ChefSpec::Stubs::DataBagItemRegistry.stub_for(bag, id)

    if stub.nil?
      raise ChefSpec::Error::DataBagItemNotStubbed.new(args: [bag, id])
    end

    stub.result
  end
end)
