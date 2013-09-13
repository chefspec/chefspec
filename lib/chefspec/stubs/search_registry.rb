require_relative 'registry'

module ChefSpec
  module Stubs
    class SearchRegistry < Registry
      def stub_for(type, query = '*:*')
        @stubs.find do |stub|
          stub.type.to_s == type.to_s && stub.query === query
        end
      end
    end
  end
end
