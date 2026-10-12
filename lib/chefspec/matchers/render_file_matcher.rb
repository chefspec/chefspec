module ChefSpec::Matchers
  #
  # Asserts that the Chef run rendered a file at a given path.
  #
  # Built by {ChefSpec::API::RenderFile#render_file}. The path may be backed by
  # a +cookbook_file+, +file+, or +template+ resource; chain {#with_content} to
  # also assert on what was written.
  #
  # @example
  #   expect(chef_run).to render_file("/etc/foo").with_content("bar")
  #
  class RenderFileMatcher
    attr_reader :expected_content
    #
    # Create a new matcher for the given path.
    #
    # @param [String] path
    #   the path the Chef run is expected to render
    #
    def initialize(path)
      @path = path
      @expected_content = []
    end

    #
    # Determine whether the file was rendered with the expected content.
    #
    # Marks the backing resource as covered in the coverage report as a side
    # effect.
    #
    # @param [ChefSpec::SoloRunner, ChefSpec::ServerRunner] runner
    #   the converged runner to inspect
    #
    # @return [true, false]
    #
    def matches?(runner)
      @runner = runner

      if resource
        ChefSpec::Coverage.cover!(resource)
        has_create_action? && matches_content?
      else
        false
      end
    end

    #
    # Assert on the rendered content of the file.
    #
    # May be chained more than once, in which case every expectation must pass.
    # Exactly one of +expected_content+ or a block must be given.
    #
    # @example Matching a substring
    #   expect(chef_run).to render_file("/etc/foo").with_content("bar")
    #
    # @example Matching with a block
    #   expect(chef_run).to render_file("/etc/foo").with_content { |content|
    #     expect(content).to include("bar")
    #   }
    #
    # @param [String, Regexp, RSpec::Matchers::BuiltIn::BaseMatcher] expected_content
    #   the content to match against the rendered file
    #
    # @yieldparam [String] content
    #   the rendered content, for making arbitrary assertions
    #
    # @raise [ArgumentError]
    #   if both a value and a block are given, or neither is
    #
    # @return [self]
    #
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

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
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

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
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

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
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

    def resource
      return @resource if defined?(@resource)

      candidates = %i{cookbook_file file template}.filter_map do |type|
        @runner.find_resource(type, @path)
      end

      # A recipe may declare more than one resource for the same path, most
      # commonly a template that creates the file and a file resource that
      # deletes it, with guards selecting between them. Prefer whichever
      # resource actually creates the file so that we do not report the file as
      # unrendered just because a sibling delete resource was found first.
      @resource = candidates.find { |candidate| create_action?(candidate) } || candidates.first
    end

    #
    # Determines if the given resource has a create-like action.
    #
    # @param [Chef::Resource] resource
    #
    # @return [true, false]
    #
    def has_create_action?
      create_action?(resource)
    end

    #
    # Determines if the given resource has a create-like action.
    #
    # @param [Chef::Resource] resource
    #
    # @return [true, false]
    #
    def create_action?(resource)
      %i{create create_if_missing}.any? { |action| resource.performed_action?(action) }
    end

    #
    # Determines if the resources content matches the expected content.
    #
    # @param [Chef::Resource] resource
    #
    # @return [true, false]
    #
    def matches_content?
      return true if @expected_content.empty?

      @actual_content = ChefSpec::Renderer.new(@runner, resource).content

      return false if @actual_content.nil?

      # Knock out matches that pass. When we're done, we pass if the list is
      # empty. Otherwise, @expected_content is the list of matchers that
      # failed
      @expected_content.delete_if do |expected|
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
      @expected_content.empty?
    end
  end
end
