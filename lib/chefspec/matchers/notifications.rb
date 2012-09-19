require 'chefspec/matchers/shared'

module ChefSpec
  module Matchers


    RSpec::Matchers.define :notify do |expected_resource,expected_resource_action|

      expected_resource.match(/^(.*)\[(.*)\]$/)
      expected_resource_name = $2
      expected_resource_type = $1
      match do |actual_resource|
        notifications = actual_resource.delayed_notifications
        notifications+= actual_resource.immediate_notifications
        notifications.any? do |rs|

          actual_resource_name = rs.resource.name.to_s
          actual_resource_type = rs.resource.resource_name.to_s
          actual_resource_action = rs.action

          (actual_resource_name == expected_resource_name) and
          (actual_resource_type == expected_resource_type) and
          (actual_resource_action.to_s == expected_resource_action.to_s)
        end
      end

      failure_message_for_should do |actual_resource|
        "expected: ['#{expected_resource_action}, #{expected_resource}']\n" +
        "     got: #{format_notifications(actual_resource)}  "
      end

      def format_notifications(resource)
        notifications = resource.delayed_notifications
        notifications += resource.immediate_notifications
        msg="["
        notifications.each do |res|
          msg+= "'#{res.action}, #{res.resource.resource_name}[#{res.resource.name}]'"
        end
        msg+="]"
      end
    end
  end
end
