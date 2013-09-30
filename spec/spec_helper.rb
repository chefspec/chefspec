require 'simplecov'
SimpleCov.start

require 'chefspec'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end

# If an RSpec Matcher is defined
#
# @param [Symbol] matcher_sym The matcher to test for
# @return [Boolean] True if the matcher has been defined
def matcher_defined?(matcher)
  RSpec::Matchers.method_defined?(matcher)
end

# The assumption is that the specs are contained in a cookbook, and the cookbook
# lives with its siblings nested in a directory (i.e. the cookbook path ).
#
# @return [String] path to the directory containing this project
def cookbook_path
  File.expand_path('../../..', __FILE__)
end

class ErrorStub < StandardError
  def initialize(*args)
    super(args.first)
    @args = args
  end
end
