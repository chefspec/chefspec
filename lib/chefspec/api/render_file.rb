module ChefSpec::API
  #
  # Assert that a file is rendered by the Chef run. This matcher works for
  # +template+, +file+, and +cookbook_file+ resources. The content from the
  # resource must be convertable to a string; verifying the content of a
  # binary file is not permissible at this time.
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
  # @example Assert a template is rendered with content matching any RSpec matcher
  #   expect(template).to render_file('/etc/foo').with_content(starts_with('This'))
  #
  # @example Assert a partial path to a template is rendered with matching content
  #   expect(template).to render_file(/\/etc\/foo-(\d+)$/).with_content(/^This(.+)$/)
  #
  #
  # @param [String] path
  #   the path of the file to render
  #
  # @return [ChefSpec::Matchers::RenderFileMatcher]
  #
  def render_file(path)
    ChefSpec::Matchers::RenderFileMatcher.new(path)
  end
end
