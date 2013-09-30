RSpec.configure do |config|
  config.include(ChefSpec::API)
  config.include(ChefSpec::Macros)

  config.after(:each) do
    ChefSpec::Stubs::CommandRegistry.reset!
    ChefSpec::Stubs::DataBagRegistry.reset!
    ChefSpec::Stubs::DataBagItemRegistry.reset!
    ChefSpec::Stubs::SearchRegistry.reset!
  end
end
