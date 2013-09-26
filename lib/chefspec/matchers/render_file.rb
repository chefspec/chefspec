module ChefSpec
  module Matchers
    #
    # Assert that a file is rendered by the Chef run. This matcher works for
    # template, file, and cookbook_file resources. The content from the resource
    # must be convertable to a string; verifying the content of a binary file
    # is not permissible at this time.
    #
    # @example Assert a template is rendered
    #   expect(chef_run).to render_file('/etc/foo')
    #
    # @example Assert a template is rendered with certain content
    #   expect(template).to render_file('/etc/foo').with_content('This is a file')
    #
    # @example Assert a template is rendered with matching content
    #   expect(template).to render_file('/etc/foo').with_content(/^This(.+)$/)
    #
    # @example Assert a partial path to a template is rendered with matching content
    #   expect(template).to render_file(/\/etc\/foo-(\d+)$/).with_content(/^This(.+)$/)
    #
    RSpec::Matchers.define(:render_file) do |path, expected|
      match do |chef_run|
        chef_run.resources.any? do |_, resource|
          if file_resource?(resource) &&
             (path === resource.identity || path === resource.name) &&
             has_create_action?(resource) &&
             matches_content?(resource)
             true
          else
            false
          end
        end
      end

      chain(:with_content) do |content|
        @expected_content = content
      end

      failure_message_for_should do |actual|
        message = "expected Chef run to render '#{path}'"
        message << " with:\n\n#{@expected_content}\n\nbut got:\n\n#{@actual_content}" if @expected_content
        message
      end

      failure_message_for_should_not do |actual|
        message = "expected render '#{path}' "
        message << " with:\n\n#{@expected_content}\n\n" if @expected_content
        message << " to not be in Chef run"
      end

      #
      # Determines if a resource is a file-like resource (file, cookbook_file,
      # or template).
      #
      # @param [Chef::Resource] resource
      #
      # @return [Boolean]
      #
      def file_resource?(resource)
        [:file, :cookbook_file, :template].include?(resource.resource_name.to_sym)
      end

      #
      # Determines if the given resource has a create-like action.
      #
      # @param [Chef::Resource] resource
      #
      # @return [Boolean]
      #
      def has_create_action?(resource)
        !([:create, :create_if_missing] & Array(resource.action).map(&:to_sym)).empty?
      end

      #
      # Determines if the resources content matches the expected content.
      #
      # @param [Chef::Resource] resource
      #
      # @return [Boolean]
      #
      def matches_content?(resource)
        return true if @expected_content.nil?

        @actual_content = ChefSpec::Renderer.new(chef_run, resource).content

        return false if @actual_content.nil?

        if @expected_content.is_a?(Regexp)
          @actual_content =~ @expected_content
        else
          @actual_content.include?(@expected_content)
        end
      end
    end
  end
end
