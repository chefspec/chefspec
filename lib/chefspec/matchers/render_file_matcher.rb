module ChefSpec::Matchers
  class RenderFileMatcher
    attr_reader :expected_content
    def initialize(path)
      @path = path
    end

    def matches?(runner)
      @runner = runner

      if resource
        ChefSpec::Coverage.cover!(resource)
        has_create_action? && matches_content?
      else
        false
      end
    end

    def with_content(expected_content = nil, &block)
      if expected_content && block
        raise ArgumentError, "Cannot specify expected content and a block!"
      elsif expected_content
        @expected_content = expected_content
      elsif block_given?
        @expected_content = block
      else
        raise ArgumentError, "Must specify expected content or a block!"
      end

      self
    end

    def description
      message = %Q{render file "#{@path}"}
      if @expected_content
        if @expected_content.to_s.include?("\n")
          message << " with content <suppressed>"
        else
          message << " with content #{@expected_content.inspect}"
        end
      end
      message
    end

    def failure_message
      message = %Q{expected Chef run to render "#{@path}"}
      if @expected_content
        message << " matching:"
        message << "\n\n"
        message << expected_content_message
        message << "\n\n"
        message << "but got:"
        message << "\n\n"
        message << @actual_content.to_s
        message << "\n "
      end
      message
    end

    def failure_message_when_negated
      message = %Q{expected file "#{@path}"}
      if @expected_content
        message << " matching:"
        message << "\n\n"
        message << expected_content_message
        message << "\n\n"
      end
      message << " to not be in Chef run"
      message
    end

    private

    def expected_content_message
      if RSpec::Matchers.is_a_matcher?(@expected_content) && @expected_content.respond_to?(:description)
        @expected_content.description
      elsif @expected_content.is_a?(Proc)
        "(the result of a proc)"
      else
        @expected_content.to_s
      end
    end

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
    # @return [true, false]
    #
    def has_create_action?
      [:create, :create_if_missing].any? { |action| resource.performed_action?(action) }
    end

    #
    # Determines if the resources content matches the expected content.
    #
    # @param [Chef::Resource] resource
    #
    # @return [true, false]
    #
    def matches_content?
      return true if @expected_content.nil?

      @actual_content = ChefSpec::Renderer.new(@runner, resource).content

      return false if @actual_content.nil?

      if @expected_content.is_a?(Regexp)
        @actual_content =~ @expected_content
      elsif RSpec::Matchers.is_a_matcher?(@expected_content)
        @expected_content.matches?(@actual_content)
      elsif @expected_content.is_a?(Proc)
        @expected_content.call(@actual_content)
        # Weird RSpecish, but that block will return false for a negated check,
        # so we always return true. The block will raise an exception if the
        # assertion fails.
        true
      else
        @actual_content.include?(@expected_content)
      end
    end
  end
end
