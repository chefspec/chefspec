require 'chef/dsl/data_query'

module Chef::DSL::DataQuery
  # @override Chef::DSL::DataQuery#search
  def search(*args, &block)
    type  = args[0]
    query = args[1] || '*:*'
    stub = ChefSpec::Stubs::SearchRegistry.stub_for(type, query)
    raise ChefSpec::SearchNotStubbedError.new(type, query) if stub.nil?

    stub.result
  end

  # @override Chef::DSL::DataQuery#data_bag
  def data_bag(bag)
    stub = ChefSpec::Stubs::DataBagRegistry.stub_for(bag)
    raise ChefSpec::DataBagNotStubbedError.new(bag) if stub.nil?

    stub.result
  end

  # @override Chef::DSL::DataQuery#data_bag_item
  def data_bag_item(bag, id)
    stub = ChefSpec::Stubs::DataBagItemRegistry.stub_for(bag, id)
    raise ChefSpec::DataBagItemNotStubbedError.new(bag, id) if stub.nil?

    stub.result
  end
end
