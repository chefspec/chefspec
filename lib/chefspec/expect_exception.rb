class RSpec::Matchers::BuiltIn::RaiseError
  class << self
    attr_accessor :last_run
  end

  attr_reader :expected_message

  def last_error_for_chefspec
    @expected_error
  end

  alias_method :old_matches?, :matches?
  def matches?(*args)
    self.class.last_run = self
    old_matches?(*args)
  end
end

module ChefSpec
  class ExpectException
    def initialize(formatter_exception, formatter_message = nil)
      @formatter_exception = formatter_exception
      @formatter_message   = formatter_message
      @matcher             = RSpec::Matchers::BuiltIn::RaiseError.last_run
    end

    def expected?
      return false if @matcher.nil?
      exception_matched? && message_matched?
    end

    private

    def exception_matched?
      @formatter_exception == @matcher.last_error_for_chefspec ||
      @matcher.last_error_for_chefspec === @formatter_exception
    end

    def message_matched?
      case @formatter_message
      when nil
        true
      when Regexp
        @matcher.expected_message =~ @formatter_message
      else
        @matcher.expected_message == @formatter_message
      end
    end
  end
end
