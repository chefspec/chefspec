module ChefSpec::Matchers
  class RenderFileMatcher
    attr_reader :expected_content
    def initialize(path)
      @path = path
      @expected_content = []
    end

    def matches?(runner)
      @runner = runner

      unless resources.empty?
        resources.each { |r| ChefSpec::Coverage.cover!(r) }
        has_create_action? && matches_content?
      else
        false
      end
    end

    def with_content(expected_content = nil, &block)
      if expected_content && block
        raise ArgumentError, "Cannot specify expected content and a block!"
      elsif expected_content
        @expected_content << expected_content
      elsif block_given?
        @expected_content << block
      else
        raise ArgumentError, "Must specify expected content or a block!"
      end

      self
    end

    def description
      message = %Q{render file "#{@path}"}
      @expected_content.each do |expected|
        if expected.to_s.include?("\n")
          message << " with content <suppressed>"
        else
          message << " with content #{expected.inspect}"
        end
      end
      message
    end

    def failure_message
      message = %Q{expected Chef run to render "#{@path}"}
      unless @expected_content.empty?
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
      unless @expected_content.empty?
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
      messages = @expected_content.collect do |expected|
        if RSpec::Matchers.is_a_matcher?(expected) && expected.respond_to?(:description)
          expected.description
        elsif expected.is_a?(Proc)
          "(the result of a proc)"
        else
          expected.to_s
        end
      end
      messages.join("\n\n")
    end

    def resources
      @resources ||= [
        @runner.find_resource(:cookbook_file, @path),
        @runner.find_resource(:file, @path),
        @runner.find_resource(:template, @path),
      ].compact.uniq
    end

    #
    # Determines if any of the given resources have a create-like action.
    #
    # @return [true, false]
    #
    def has_create_action?
      %i{create create_if_missing}.any? do |action|
        resources.any? do |resource|
          resource.performed_action?(action)
        end
      end
    end

    #
    # Determines if any of the resources' content matches the expected content.
    #
    # @return [true, false]
    #
    def matches_content?
      return true if @expected_content.empty?

      # Knock out matches that pass. When we're done, we pass if the list is
      # empty. Otherwise, @expected_content is the list of matchers that
      # failed
      @expected_content.delete_if do |expected|
        resources.each do |resource|
          @actual_content = ChefSpec::Renderer.new(@runner, resource).content

          next if @actual_content.nil?

          if expected.is_a?(Regexp)
            @actual_content =~ expected
          elsif RSpec::Matchers.is_a_matcher?(expected)
            expected.matches?(@actual_content)
          elsif expected.is_a?(Proc)
            expected.call(@actual_content)
            # Weird RSpecish, but that block will return false for a negated check,
            # so we always return true. The block will raise an exception if the
            # assertion fails.
            true
          else
            @actual_content.include?(expected)
          end
        end
      end
      @expected_content.empty?
    end
  end
end
