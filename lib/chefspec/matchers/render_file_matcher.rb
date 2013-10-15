module ChefSpec::Matchers
  class RenderFileMatcher
    def initialize(path)
      @path = path
    end

    def matches?(runner)
      @runner = runner
      resource && has_create_action? && matches_content?
    end

    def with_content(expected_content)
      @expected_content = expected_content
      self
    end

    def description
      "render file '#{@path}'"
    end

    def failure_message_for_should
      message = "expected Chef run to render '#{@path}'"
      if @expected_content
        message << " with:"
        message << "\n\n"
        message << @expected_content
        message << "\n\n"
        message << "but got:"
        message << "\n\n"
        message << @actual_content
        message << "\n "
      end
      message
    end

    def failure_message_for_should_not
      message = "expected file '#{@path}'"
      if @expected_content
        message << " with:"
        message << "\n\n"
        message << @expected_content
        message << "\n\n"
      end
      message << " to not be in Chef run"
    end

    private
      def resource
        @resource ||= @runner.find_resource(:cookbook_file, @path) ||
                      @runner.find_resource(:file, @path) ||
                      @runner.find_resource(:template, @path)
      end

      #
      # Determines if the given resource has a create-like action.
      #
      # @param [Chef::Resource] resource
      #
      # @return [Boolean]
      #
      def has_create_action?
        !([:create, :create_if_missing] & Array(resource.action).map(&:to_sym)).empty?
      end

      #
      # Determines if the resources content matches the expected content.
      #
      # @param [Chef::Resource] resource
      #
      # @return [Boolean]
      #
      def matches_content?
        return true if @expected_content.nil?

        @actual_content = ChefSpec::Renderer.new(@runner, resource).content

        return false if @actual_content.nil?

        if @expected_content.is_a?(Regexp)
          @actual_content =~ @expected_content
        else
          @actual_content.include?(@expected_content)
        end
      end
  end
end
