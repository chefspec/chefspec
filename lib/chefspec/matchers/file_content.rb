require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers
    RSpec::Matchers.define :create_file_with_content do |path, expected|
      match do |chef_run|
        chef_run.resources.select { |resource| resource.name == path }.any? do |resource|
          unless ([:create, :create_if_missing] & Array(resource.action).map(&:to_sym)).empty?
            @actual_content = case resource_type(resource)
            when 'template'
              content_from_template(chef_run, resource)
            when 'file'
              content_from_file(chef_run, resource)
            when 'cookbook_file'
              content_from_cookbook_file(chef_run, resource)
            end

            if expected.is_a?(Regexp)
              @actual_content.to_s =~ expected
            else
              @actual_content.to_s.include?(expected)
            end
          end
        end
      end

      failure_message_for_should do |actual|
        "File content:\n#{@actual_content} does not match expected:\n#{expected}"
      end
    end
  end
end
