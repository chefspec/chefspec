require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :create_file_with_content do |path, content|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          if resource.name == path
            if (Array(resource.action).map { |action| action.to_sym } & [:create, :create_if_missing]).any?
              case resource_type(resource)
                when 'template'
                  @actual_content = render(resource, chef_run.node)
                when 'file'
                  @actual_content = resource.content
                when 'cookbook_file'
                  cookbook_name = resource.cookbook || resource.cookbook_name
                  cookbook = chef_run.node.cookbook_collection[cookbook_name]
                  @actual_content = File.read(cookbook.preferred_filename_on_disk_location(chef_run.node, :files, resource.source, resource.path))
              end

              if content.is_a?(Regexp)
                @actual_content.to_s =~ content
              else
                @actual_content.to_s.include? content
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
