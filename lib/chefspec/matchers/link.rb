require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    define_resource_matchers([:create, :delete], [:link], :target_file)

    RSpec::Matchers.define :link_to do |path|
      match do |link|
        link.nil? ? false : link.to == path
      end
    end
  end
end
