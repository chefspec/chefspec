module ChefSpec::API
  #
  # Assert that a symlink links to a specific path. This is really
  # syntactic sugar for the following:
  #
  #       expect(chef_run).to create_link('/tmp/thing').with(to: '/tmp/other_thing')
  #
  # @example Using +link_to+ with a String path
  #   link = chef_run.link('/tmp/thing')
  #   expect(link).to link_to('/tmp/other_thing')
  #
  # @example Using +link_to+ with a regular expression
  #   expect(link).to link_to(/\/tmp/(.+)/)
  #
  # @param [String, Regex] path
  #   the path to link to
  #
  # @return [ChefSpec::Matchers::LinkToMatcher]
  #
  def link_to(path)
    ChefSpec::Matchers::LinkToMatcher.new(path)
  end
end
