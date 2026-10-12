module ChefSpec
  #
  # Namespace for the stub and registry objects backing +stub_command+,
  # +stub_search+, +stub_data_bag+, and +stub_data_bag_item+.
  #
  module Stubs
    #
    # Base class for a single stubbed call.
    #
    # A stub records what it was asked to return and replays it on demand.
    # Subclasses add the arguments that identify the call and implement
    # +#signature+, which is what the "not stubbed" error prints as a suggestion.
    #
    class Stub
      attr_reader :value

      #
      # Set the value the stubbed call returns.
      #
      # @param [Object] value
      #   the value to return
      #
      # @return [self]
      #
      def and_return(value)
        @value = value
        self
      end

      #
      # Raise an exception instead of returning a value.
      #
      # @param [Exception, Class] exception
      #   the exception to raise
      #
      # @return [self]
      #
      def and_raise(exception)
        @block = proc { raise exception }
        self
      end

      #
      # The value this stub returns, with hashes converted to +Mash+ so that
      # cookbook code can use string or symbol keys interchangeably.
      #
      # @return [Object]
      #
      def result
        if @block
          recursively_mashify(@block.call)
        else
          recursively_mashify(@value)
        end
      end

      private

      def recursively_mashify(thing)
        case thing
        when Array
          thing.collect { |item| recursively_mashify(item) }
        when Hash
          Mash.from_hash(thing)
        else
          thing
        end
      end
    end
  end
end
