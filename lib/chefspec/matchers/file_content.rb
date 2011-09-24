require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :create_file_with_content do |path, content|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          if resource.name == path
            if resource.action.include?(:create) || resource.action.include?(:create_if_missing)
              case resource_type(resource)
                when 'template'
                  @actual_content = render(resource, chef_run.node)
                  content == @actual_content
                when 'file'
                  @actual_content = resource.content
                  content == @actual_content
              end
            end
          end
        end
      end
      failure_message_for_should do |actual|
        "File content:\n#{@actual_content} does not match expected:\n#{content}"
      end
    end
  end
end