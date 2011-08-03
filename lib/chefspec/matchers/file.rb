require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    define_resource_matchers([:create, :delete], [:file, :directory], :path)

    RSpec::Matchers.define :be_owned_by do |user, group|
      match do |file|
        file.nil? ? false : file.owner == user and file.group == group
      end
    end
  end
end