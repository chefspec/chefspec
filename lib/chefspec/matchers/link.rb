module ChefSpec
  module Matchers
    define_resource_matchers([:create, :delete], [:link])

    #
    # Assert that a symlink links to a specific path. This is really
    # syntactic sugar for the following:
    #
    # @example Without link_to
    #   expect(chef_run).to create_link('/tmp/thing').with(to: '/tmp/other_thing')
    #
    # @example Using link_to
    #   link = chef_run.link('/tmp/thing')
    #   expect(link).to link_to('/tmp/other_thing')
    #
    # @example Using a regular expression
    #   expect(link).to link_to(/\/tmp/(.+)/)
    #
    RSpec::Matchers.define(:link_to) do |path|
      match do |link|
        link.is_a?(Chef::Resource::Link) && path === link.to
      end

      failure_message_for_should do |actual|
        if actual.nil?
          "expected 'link[#{path}]' with action ':create' to be in Chef run"
        else
          "expected '#{actual}' to link to '#{path}' but was '#{actual.to}'"
        end
      end

      failure_message_for_should_not do |actual|
        "expected '#{actual}' to not link to '#{path}'"
      end
    end
  end
end
