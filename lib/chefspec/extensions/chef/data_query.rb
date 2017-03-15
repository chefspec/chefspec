require 'chef/dsl/data_query'

module Chef::DSL::DataQuery
  # @see Chef::DSL::DataQuery#search
  alias_method :old_search, :search
  def search(*args, &block)
    return old_search(*args, &block) unless Chef::Config[:solo]

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
  alias_method :old_data_bag, :data_bag
  def data_bag(bag)
    return old_data_bag(bag) unless Chef::Config[:solo]

    stub = ChefSpec::Stubs::DataBagRegistry.stub_for(bag)

    if stub.nil?
      raise ChefSpec::Error::DataBagNotStubbed.new(args: [bag])
    end

    stub.result
  end

  # @see Chef::DSL::DataQuery#data_bag_item
  alias_method :old_data_bag_item, :data_bag_item
  def data_bag_item(bag, id, secret = nil)
    return old_data_bag_item(bag, id, secret) unless Chef::Config[:solo]

    stub = ChefSpec::Stubs::DataBagItemRegistry.stub_for(bag, id)

    if stub.nil?
      raise ChefSpec::Error::DataBagItemNotStubbed.new(args: [bag, id])
    end

    stub.result
  end
end
