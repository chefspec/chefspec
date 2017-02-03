# We need to add this setting because for the first test, we haven't had a chance
# to load the chefspec rspec.rb file, so the first test will fail if we simply
# try to set it like we would otherwise.

RSpec.configure do |config|
  config.add_setting :server_runner_data_store, default: :on_disk
end
