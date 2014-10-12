module ChefSpec::API
  # @since 0.0.1
  module TemplateMatchers
    ChefSpec.define_matcher :template

    #
    # Assert that a +template+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "/tmp/config" as a
    # +template+:
    #
    #     template '/tmp/config' do
    #       action :create
    #     end
    #
    # To test the content rendered by a +template+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +template+ resource with ChefSpec.
    #
    # @example Assert that a +template+ was created
    #   expect(chef_run).to create_template('/tmp/config')
    #
    # @example Assert that a +template+ was created with predicate matchers
    #   expect(chef_run).to create_template('/tmp/config').with_user('svargo')
    #
    # @example Assert that a +template+ was created with attributes
    #   expect(chef_run).to create_template('/tmp/config').with(user: 'svargo')
    #
    # @example Assert that a +template+ was created using a regex
    #   expect(chef_run).to create_template('/tmp/config').with(user: /sva(.+)/)
    #
    # @example Assert that a +template+ was _not_ created
    #   expect(chef_run).to_not create_template('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_template(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:template, :create, resource_name)
    end

    #
    # Assert that a +template+ resource exists in the Chef run with the
    # action +:create_if_missing+. Given a Chef Recipe that creates "/tmp/config"
    # if missing as a +template+:
    #
    #     template '/tmp/config' do
    #       action :create_if_missing
    #     end
    #
    # To test the content rendered by a +template+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +template+ resource with ChefSpec.
    #
    # @example Assert that a +template+ was created if missing
    #   expect(chef_run).to create_template_if_missing('/tmp/config')
    #
    # @example Assert that a +template+ was created if missing with predicate matchers
    #   expect(chef_run).to create_template_if_missing('/tmp/config').with_user('svargo')
    #
    # @example Assert that a +template+ was created if missing with attributes
    #   expect(chef_run).to create_template_if_missing('/tmp/config').with(user: 'svargo')
    #
    # @example Assert that a +template+ was created if missing using a regex
    #   expect(chef_run).to create_template_if_missing('/tmp/config').with(user: /sva(.+)/)
    #
    # @example Assert that a +template+ was _not_ created if missing
    #   expect(chef_run).to_not create_template('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_template_if_missing(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:template, :create_if_missing, resource_name)
    end

    #
    # Assert that a +template+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "/tmp/config" as a
    # +template+:
    #
    #     template '/tmp/config' do
    #       action :delete
    #     end
    #
    # To test the content rendered by a +template+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +template+ resource with ChefSpec.
    #
    # @example Assert that a +template+ was deleted
    #   expect(chef_run).to delete_template('/tmp/config')
    #
    # @example Assert that a +template+ was deleted with predicate matchers
    #   expect(chef_run).to delete_template('/tmp/config').with_user('svargo')
    #
    # @example Assert that a +template+ was deleted with attributes
    #   expect(chef_run).to delete_template('/tmp/config').with(user: 'svargo')
    #
    # @example Assert that a +template+ was deleted using a regex
    #   expect(chef_run).to delete_template('/tmp/config').with(user: /sva(.+)/)
    #
    # @example Assert that a +template+ was _not_ deleted
    #   expect(chef_run).to_not delete_template('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_template(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:template, :delete, resource_name)
    end

    #
    # Assert that a +template+ resource exists in the Chef run with the
    # action +:touch+. Given a Chef Recipe that touches "/tmp/config" as a
    # +template+:
    #
    #     template '/tmp/config' do
    #       action :touch
    #     end
    #
    # To test the content rendered by a +template+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +template+ resource with ChefSpec.
    #
    # @example Assert that a +template+ was touched
    #   expect(chef_run).to touch_template('/tmp/config')
    #
    # @example Assert that a +template+ was touched with predicate matchers
    #   expect(chef_run).to touch_template('/tmp/config').with_user('svargo')
    #
    # @example Assert that a +template+ was touched with attributes
    #   expect(chef_run).to touch_template('/tmp/config').with(user: 'svargo')
    #
    # @example Assert that a +template+ was touched using a regex
    #   expect(chef_run).to touch_template('/tmp/config').with(user: /sva(.+)/)
    #
    # @example Assert that a +template+ was _not_ touched
    #   expect(chef_run).to_not touch_template('/tmp/config')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def touch_template(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:template, :touch, resource_name)
    end
  end
end
