RSpec.configure do |config|
  unless ENV['CHEFSPEC_NO_INCLUDE']
    config.include(ChefSpec::API)
  end

  config.add_setting :berkshelf_options, default: {}
  config.add_setting :policyfile_path
  config.add_setting :file_cache_path
  config.add_setting :cookbook_root
  config.add_setting :cookbook_path
  config.add_setting :role_path
  config.add_setting :environment_path
  config.add_setting :file_cache_path
  config.add_setting :log_level, default: :warn
  config.add_setting :path
  config.add_setting :platform
  config.add_setting :version
  config.add_setting :server_runner_data_store, default: :in_memory
  config.add_setting :server_runner_clear_cookbooks, default: true
  config.add_setting :server_runner_port, default: (8889..8899)
end
