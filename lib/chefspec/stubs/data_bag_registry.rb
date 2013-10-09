require_relative 'registry'

module ChefSpec
  module Stubs
    class DataBagRegistry < Registry
      def stub_for(bag)
        @stubs.find do |stub|
          stub.bag.to_s == bag.to_s
        end
      end
    end
  end
end
