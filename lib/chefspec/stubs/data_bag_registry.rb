require_relative "registry"

module ChefSpec
  module Stubs
    #
    # Registry of data bag stubs declared by the example.
    #
    class DataBagRegistry < Registry
      #
      # Find the most recently registered stub matching the given data bag.
      #
      #
      # @param [String, Symbol] bag
      #   the data bag the cookbook tried to load
      #
      #
      # @return [ChefSpec::Stubs::Stub, nil]
      #
      def stub_for(bag)
        @stubs.find do |stub|
          stub.bag.to_s == bag.to_s
        end
      end
    end
  end
end
