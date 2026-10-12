module ChefSpec::Matchers
  #
  # Asserts that a +link+ resource points at a given target.
  #
  # Built by {ChefSpec::API::Link#link_to}. The target is compared with +===+,
  # so a regular expression may be given instead of a literal path.
  #
  # @example
  #   expect(chef_run.link("/tmp/thing")).to link_to("/tmp/other_thing")
  #
  class LinkToMatcher
    #
    # Create a new matcher for the given link target.
    #
    # @param [String, Regexp] path
    #   the path the link is expected to point at
    #
    def initialize(path)
      @path = path
    end

    #
    # Determine whether the resource is a created link pointing at the target.
    #
    # Marks the resource as covered in the coverage report as a side effect.
    #
    # @param [Chef::Resource::Link] link
    #   the link resource to inspect
    #
    # @return [true, false]
    #
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

    #
    # The RSpec description for this matcher, used when an example has no
    # explicit doc string.
    #
    # @return [String]
    #
    def description
      %Q{link to "#{@path}"}
    end

    #
    # The message shown when the matcher was expected to match but did not.
    #
    # @return [String]
    #
    def failure_message
      if @link.nil?
        %Q{expected "link[#{@path}]" with action :create to be in Chef run}
      else
        %Q{expected "#{@link}" to link to "#{@path}" but was "#{@link.to}"}
      end
    end

    #
    # The message shown when the matcher was expected not to match but did.
    #
    # @return [String]
    #
    def failure_message_when_negated
      %Q{expected "#{@link}" to not link to "#{@path}"}
    end
  end
end
