require 'chefspec'
require 'support/hash'

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end
