require_relative "registry"

module ChefSpec
  module Stubs
    #
    # Registry of search stubs declared by the example.
    #
    class SearchRegistry < Registry
      #
      # Find the most recently registered stub matching the given index and query.
      #
      #
      # @param [String, Symbol] type
      #   the search index, such as +:node+
      #
      # @param [String] query
      #   the search query the cookbook ran
      #
      #
      # @return [ChefSpec::Stubs::Stub, nil]
      #
      def stub_for(type, query = "*:*")
        @stubs.find do |stub|
          stub.type.to_s == type.to_s && stub.query === query
        end
      end
    end
  end
end
