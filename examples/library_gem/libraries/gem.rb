run_context = Chef::RunContext.new(Chef::Node.new, {}, Chef::EventDispatch::Dispatcher.new)
chef_gem = Chef::Resource::ChefGem.new("whatever", run_context)
chef_gem.run_action(:install)
