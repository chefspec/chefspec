class Chef
  module ExpectException
    class << self
      def expected?(chef_message, exception, *args)
        @block.call(chef_message, exception)
      end

      def expect(klass, message)
        expect_block do |chef_message, exception|
          match?(exception, klass, message)
        end
      end

      def expect_block(&block)
        @block = block
      end

      def clear
        @block = lambda { |cm, e| false }
        clear_seen
      end

      def clear_seen
        @seen = []
      end

      def match?(exception, klass, message)
        exception.class == klass and exception.message == message
      end
    end

    clear
  end
end
