require 'chefspec'
require 'support/examples'
require 'support/hash'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end

# Test if an RSpec Matcher is defined
#
# @param [Symbol] matcher
#   The matcher to test for
#
# @return [Boolean]
def matcher_defined?(matcher)
  RSpec::Matchers.method_defined?(matcher)
end

# The assumption is that the specs are contained in a cookbook, and the
# cookbook lives with its siblings nested in a directory (i.e. the cookbook
# path).
#
# @return [String]
def cookbook_path
  File.expand_path(File.join('..', '..', '..'), __FILE__)
end

class ErrorStub < StandardError
  def initialize(*args)
    super(args.first)
    @args = args
  end
end

