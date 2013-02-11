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
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'remote_file' &&
            resource.path == path &&
            resource.action.to_s == 'create'
        end
      end
      failure_message_for_should do |actual|
        "No remote_file named '#{path}' found."
      end
      failure_message_for_should_not do |actual|
        "Found remote_file named '#{path}' that should not exist."
      end
    end

    RSpec::Matchers.define :create_remote_file_with_attributes do |path, attributes|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'remote_file' &&
            resource.path == path &&
            attributes.all? { |k,v| resource.send(k) == attributes[k] }
        end
      end
    end
  end
end
