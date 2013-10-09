module ChefSpec
  module Stubs
    class Registry
      class << self
        extend Forwardable
        def_delegators :instance, :reset!, :register, :stubs, :stubs=, :stub_for
      end

      include Singleton

      # @return [Hash<Symbol, Array<SearchStub>>]
      attr_accessor :stubs

      def initialize
        reset!
      end

      def reset!
        @stubs = []
      end

      def register(stub)
        @stubs.insert(0, stub)
        stub
      end

      def stub_for(*args)
        raise ArgumentError, '#stub_for is an abstract function'
      end
    end
  end
end
