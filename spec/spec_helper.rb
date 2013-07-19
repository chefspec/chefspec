require 'simplecov'
SimpleCov.start

require 'chefspec'

# If an RSpec Matcher is defined
#
# @param [Symbol] matcher_sym The matcher to test for
# @return [Boolean] True if the matcher has been defined
def matcher_defined?(matcher)
  RSpec::Matchers.method_defined?(matcher)
end

class ErrorStub < StandardError
  def initialize(*args)
    super(args.first)
    @args = args
  end
end

