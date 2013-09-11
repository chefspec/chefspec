require 'chefspec/matchers/shared'

module ChefSpec
  # RSpec Matchers
  module Matchers
    RSpec::Matchers.define(:log) do |message|
      match do |chef_run|
        chef_run.resources.any? do |resource|
          resource_type(resource) == 'log' &&
          message === log_message(resource) &&
          expected_attributes?(resource)
        end
      end

      chain(:with) do |attributes|
        @attributes = attributes
      end

      failure_message_for_should do |chef_run|
        "expected log[#{message}] to be in Chef run"
      end

      failure_message_for_should_not do |chef_run|
        "expected log[#{message}] to not be in Chef run"
      end

      # Calculate the log message for the given resource, because
      # Chef 10.18 added message attribute to the log resource.
      def log_message(resource)
        resource.respond_to?(:message) ? resource.message : resource.name
      end

      def expected_attributes?(resource)
        (@attributes || {}).all? { |k, v| v === resource.send(k) }
      end
    end
  end
end
