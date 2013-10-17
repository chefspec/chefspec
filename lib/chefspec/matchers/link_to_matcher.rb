module ChefSpec::Matchers
  class LinkToMatcher
    def initialize(path)
      @path = path
    end

    def matches?(link)
      @link = link

      @link.is_a?(Chef::Resource::Link) &&
      @link.performed_action?(:create) &&
      @path === @link.to
    end

    def description
      "link to '#{@path}'"
    end

    def failure_message_for_should
      if @link.nil?
        "expected 'link[#{@path}]' with action ':create' to be in Chef run"
      else
        "expected '#{@link}' to link to '#{@path}' but was '#{@link.to}'"
      end
    end

    def failure_message_for_should_not
      "expected '#{@link}' to not link to '#{@path}'"
    end
  end
end
