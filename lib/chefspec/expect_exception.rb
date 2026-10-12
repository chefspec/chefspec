#
# Reopened so ChefSpec can see the most recently run +raise_error+ matcher.
#
# Chef swallows exceptions inside the converge and reports them through the
# formatter instead of re-raising, so {ChefSpec::ExpectException} needs the
# matcher itself to decide whether the failure was the expected one.
#
# @api private
#
class RSpec::Matchers::BuiltIn::RaiseError
  class << self
    #
    # The most recently evaluated +raise_error+ matcher, recorded so ChefSpec
    # can consult it after Chef swallows the exception.
    #
    # @return [RSpec::Matchers::BuiltIn::RaiseError, nil]
    #
    attr_accessor :last_run
  end

  #
  # The message this matcher was built to expect.
  #
  # @return [String, Regexp, nil]
  #
  attr_reader :expected_message

  #
  # The error class or instance this matcher was built to expect.
  #
  # @return [Exception, Class, nil]
  #
  def last_error_for_chefspec
    @expected_error
  end

  #
  # The original RSpec implementation of +matches?+, preserved so the
  # override below can record the matcher and then delegate to it.
  #
  # @return [true, false]
  #
  alias_method :old_matches?, :matches?
  def matches?(*args)
    self.class.last_run = self
    old_matches?(*args)
  end
end

module ChefSpec
  #
  # Decides whether an exception reported by the Chef formatter is the one the
  # example was expecting.
  #
  # Compares the formatter's exception and message against the most recently
  # run +raise_error+ matcher.
  #
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
