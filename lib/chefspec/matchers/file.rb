require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers

    define_resource_matchers([:create, :delete], [:file, :directory, :cookbook_file], :path)

    RSpec::Matchers.define :be_owned_by do |user, group|
      match do |file|
        file.nil? ? false : file.owner == user and file.group == group
      end
    end

    {:create_remote_file => :create, :create_remote_file_if_missing => :create_if_missing}.each do |matcher, corr_action|
      RSpec::Matchers.define matcher do |path|
        match do |chef_run|
          if @attributes
            chef_run.resources.any? do |resource|
              expected_remote_file?(resource,path,corr_action) &&
                expected_attributes?(resource)
            end
          else
            chef_run.resources.any? do |resource|
              expected_remote_file?(resource,path,corr_action)
            end
          end
        end

        chain :with do |attributes|
          @attributes = attributes
        end

        def expected_remote_file?(resource,path,corr_action)
          # The resource action *might* be an array!
          # (see https://tickets.opscode.com/browse/CHEF-2094)
          action = resource.action.is_a?(Array) ? resource.action.first :
            resource.action
          resource_type(resource) == 'remote_file' &&
            resource.path         == path &&
            action.to_sym         == corr_action
        end

        def expected_attributes?(resource)
          @attributes.all? do |attribute,expected|
            actual = resource.send(attribute)
            attribute.to_sym == :source ? equal_source?(actual, expected) :
              actual == expected
          end
        end

        # Compare two remote_file source attributes for equality.
        #
        # @param actual [String, Array<String>] The actual source.
        # @param expected [String, Array<String>] The expected source.
        # @return [Boolean] true if they are equal or false if not.
        def equal_source?(actual, expected)
          # NOTE: Chef stores the source attribute internally as an array since
          # version 11 in order to support mirrors.
          # (see http://docs.opscode.com/breaking_changes_chef_11.html#remote-file-mirror-support-may-break-subclasses)

          # Handle wrong formated expectation for Chef versions >= 11.
          if actual.is_a?(Array) && expected.is_a?(String)
            actual == [expected]

          # Handle wrong formated expectation for Chef versions < 11.
          elsif actual.is_a?(String) && expected.is_a?(Array)
            [actual] == expected

          # Else assume the actual matches the expected type (String or Array).
          else
            actual == expected
          end
        end

        failure_message_for_should do |actual|
          message = "No remote_file named '#{path}' for action #{corr_action} found"
          message << " with:\n#{@attributes}" unless @attributes.nil?
          message
        end

        failure_message_for_should_not do |actual|
          "Found remote_file named '#{path}' that should not exist."
        end
      end
    end
  end
end
