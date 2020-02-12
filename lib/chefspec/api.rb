module ChefSpec
  module API
    autoload :Core, 'chefspec/api/core'
    autoload :Described, 'chefspec/api/described'
    autoload :DoNothing, 'chefspec/api/do_nothing'
    autoload :IncludeAnyRecipe, 'chefspec/api/include_any_recipe'
    autoload :IncludeRecipe, 'chefspec/api/include_recipe'
    autoload :Link, 'chefspec/api/link'
    autoload :Notifications, 'chefspec/api/notifications'
    autoload :Reboot, 'chefspec/api/reboot'
    autoload :RenderFile, 'chefspec/api/render_file'
    autoload :StateAttrs, 'chefspec/api/state_attrs'
    autoload :Stubs, 'chefspec/api/stubs'
    autoload :StubsFor, 'chefspec/api/stubs_for'
    autoload :Subscriptions, 'chefspec/api/subscriptions'
    autoload :User, 'chefspec/api/user'

    def self.included(klass)
      # non-resources
      klass.include(ChefSpec::API::Core)
      klass.include(ChefSpec::API::Described)
      klass.include(ChefSpec::API::DoNothing)
      klass.include(ChefSpec::API::IncludeAnyRecipe)
      klass.include(ChefSpec::API::IncludeRecipe)
      klass.include(ChefSpec::API::DoNothing)
      klass.include(ChefSpec::API::RenderFile)
      klass.include(ChefSpec::API::StateAttrs)
      klass.include(ChefSpec::API::Notifications)
      klass.include(ChefSpec::API::Stubs)
      klass.include(ChefSpec::API::StubsFor)
      klass.include(ChefSpec::API::Subscriptions)

      # hacks and sugar for resources that don't follow the normal pattern
      klass.include(ChefSpec::API::User)
      klass.include(ChefSpec::API::Link)
      klass.include(ChefSpec::API::Reboot)
    end
  end
end
