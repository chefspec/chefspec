module ChefSpec
  module Stubs
    class Stub
      attr_reader :value

      def and_return(value)
        @value = value
        self
      end

      def and_raise(exception)
        @block = Proc.new { raise exception }
        self
      end

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
