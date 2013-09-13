require_relative 'registry'

module ChefSpec
  module Stubs
    class DataBagItemRegistry < Registry
      def stub_for(bag, id)
        @stubs.find do |stub|
          stub.bag.to_s == bag.to_s && stub.id === id
        end
      end
    end
  end
end
