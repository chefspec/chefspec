require 'simplecov'
SimpleCov.start

require 'aruba/cucumber'

Before do
  @aruba_timeout_seconds = 300
end

unless ENV['CS_SPEC_TYPE']
  raise ArgumentError,
    'Please set CS_SPEC_TYPE to specify the test framework to be tested against'
end
