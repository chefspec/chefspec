module ChefSpec::Matchers
  class LinkToMatcher
    def initialize(path)
      @path = path
    end

    def matches?(link)
      @link = link

      if @link
        ChefSpec::Coverage.cover!(@link)

        @link.is_a?(Chef::Resource::Link) &&
        @link.performed_action?(:create) &&
        @path === @link.to
      else
        false
      end
    end

    def description
      %Q{link to "#{@path}"}
    end

    def failure_message_for_should
      if @link.nil?
        %Q{expected "link[#{@path}]" with action :create to be in Chef run}
      else
        %Q{expected "#{@link}" to link to "#{@path}" but was "#{@link.to}"}
      end
    end

    def failure_message_for_should_not
      %Q{expected "#{@link}" to not link to "#{@path}"}
    end
  end
end
