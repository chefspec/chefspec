module ChefSpec
  module Stubs
    #
    # Base class for the singleton registries that hold stubs for an example.
    #
    # Stubs are inserted at the front of the list, so a stub declared later wins
    # over an earlier one with the same signature. Subclasses implement
    # {#stub_for} to define what "matching" means for their stub type.
    #
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

      #
      # Discard every registered stub. Called between examples.
      #
      # @return [Array]
      #
      def reset!
        @stubs = []
      end

      #
      # Add a stub to the front of the registry, so it takes precedence over any
      # previously registered stub with the same signature.
      #
      # @param [ChefSpec::Stubs::Stub] stub
      #   the stub to register
      #
      # @return [ChefSpec::Stubs::Stub]
      #   the stub that was registered
      #
      def register(stub)
        @stubs.insert(0, stub)
        stub
      end

      #
      # Find the stub matching the given arguments.
      #
      # @abstract Subclasses must implement this.
      #
      # @raise [ArgumentError]
      #   always, unless overridden by a subclass
      #
      def stub_for(*args)
        raise ArgumentError, "#stub_for is an abstract function"
      end
    end
  end
end
