require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    define_resource_matchers([:create, :delete], [:file, :directory, :cookbook_file], :path)

    RSpec::Matchers.define :be_owned_by do |user, group|
      match do |file|
        file.nil? ? false : file.owner == user and file.group == group
      end
    end

    RSpec::Matchers.define :create_remote_file do |path|
      match do |chef_run|
        if @attributes
          chef_run.resources.any? do |resource|
            expected_remote_file?(resource,path) &&
              expected_attributes?(resource)
          end
        else
          chef_run.resources.any? do |resource|
            expected_remote_file?(resource,path)
          end
        end
      end
      chain :with do |attributes|
        @attributes = attributes
      end
      def expected_remote_file?(resource,path)
        # The resource action *might* be an array!
        # (see https://tickets.opscode.com/browse/CHEF-2094)
        action = resource.action.is_a?(Array) ? resource.action.first :
          resource.action
        resource_type(resource) == 'remote_file' &&
          resource.path         == path &&
          action.to_sym         == :create
      end
      def expected_attributes?(resource)
        @attributes.all? { |k,v| resource.send(k) == @attributes[k] }
      end
      failure_message_for_should do |actual|
        "No remote_file named '#{path}' found."
      end
      failure_message_for_should_not do |actual|
        "Found remote_file named '#{path}' that should not exist."
      end
    end
  end
end
