require_relative "registry"

module ChefSpec
  module Stubs
    #
    # Registry of data bag item stubs declared by the example.
    #
    class DataBagItemRegistry < Registry
      #
      # Find the most recently registered stub matching the given data bag and item id.
      #
      #
      # @param [String, Symbol] bag
      #   the data bag the item lives in
      #
      # @param [String] id
      #   the id of the item the cookbook tried to load
      #
      #
      # @return [ChefSpec::Stubs::Stub, nil]
      #
      def stub_for(bag, id)
        @stubs.find do |stub|
          stub.bag.to_s == bag.to_s && stub.id === id
        end
      end
    end
  end
end
