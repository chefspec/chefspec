module ChefSpec::API
  # @since 4.3.0
  module DscResourceMatchers
    ChefSpec.define_matcher :dsc_resource

    #
    # Assert that a +dsc_resource+ resource exists in the Chef run with the
    # action +:run+. Given a Chef Recipe that installs "zip" as a
    # +dsc_resource+:
    #
    #     dsc_resource 'zip' do
    #       resource :archive
    #       property :ensure, 'Present'
    #       property :path, "C:\Users\Public\Documents\example.zip"
    #       property :destination, "C:\Users\Public\Documents\ExtractionPath"
    #     end
    #
    # To test the content rendered by a +dsc_resource+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +dsc_resource+ resource with ChefSpec.
    #
    # @example Assert that a +dsc_resource+ was installed
    #   expect(chef_run).to run_dsc_resource('zip')
    #
    # @example Assert that a +dsc_resource+ was installed with predicate matchers
    #   expect(chef_run).to run_dsc_resource('zip').with_resource(:archive)
    #
    # @example Assert that a +dsc_resource+ was installed with attributes
    #   expect(chef_run).to run_dsc_resource('zip').with(resource: :archive)
    #
    # @example Assert that a +dsc_resource+ was installed using a regex
    #   expect(chef_run).to run_dsc_resource('zip').with(resource: /:arch(.+)/)
    #
    # @example Assert that a +dsc_resource+ was _not_ installed
    #   expect(chef_run).to_not run_dsc_resource('zip')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def run_dsc_resource(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:dsc_resource, :run, resource_name)
    end
  end
end
