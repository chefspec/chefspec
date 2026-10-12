provides :spec_global_platform_greet

property :message, String, default: 'Hello world'

action :run do
  log new_resource.message
end
