module ChefSpec::API
  # @since 0.0.1
  module ServiceMatchers
    ChefSpec.define_matcher :service

    #
    # Assert that a +service+ resource exists in the Chef run with the
    # action +:disable+. Given a Chef Recipe that disables "apache2" as a
    # +service+:
    #
    #     service 'apache2' do
    #       action :disable
    #     end
    #
    # To test the content rendered by a +service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +service+ resource with ChefSpec.
    #
    # @example Assert that a +service+ was disabled
    #   expect(chef_run).to disable_service('apache2')
    #
    # @example Assert that a +service+ was disabled with predicate matchers
    #   expect(chef_run).to disable_service('apache2').with_pattern('apa*')
    #
    # @example Assert that a +service+ was disabled with attributes
    #   expect(chef_run).to disable_service('apache2').with(pattern: 'apa*')
    #
    # @example Assert that a +service+ was disabled using a regex
    #   expect(chef_run).to disable_service('apache2').with(patthen: /(.+)/)
    #
    # @example Assert that a +service+ was _not_ disabled
    #   expect(chef_run).to_not disable_service('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def disable_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:service, :disable, resource_name)
    end

    #
    # Assert that a +service+ resource exists in the Chef run with the
    # action +:enable+. Given a Chef Recipe that enables "apache2" as a
    # +service+:
    #
    #     service 'apache2' do
    #       action :enable
    #     end
    #
    # To test the content rendered by a +service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +service+ resource with ChefSpec.
    #
    # @example Assert that a +service+ was enabled
    #   expect(chef_run).to enable_service('apache2')
    #
    # @example Assert that a +service+ was enabled with predicate matchers
    #   expect(chef_run).to enable_service('apache2').with_pattern('apa*')
    #
    # @example Assert that a +service+ was enabled with attributes
    #   expect(chef_run).to enable_service('apache2').with(pattern: 'apa*')
    #
    # @example Assert that a +service+ was enabled using a regex
    #   expect(chef_run).to enable_service('apache2').with(patthen: /(.+)/)
    #
    # @example Assert that a +service+ was _not_ enabled
    #   expect(chef_run).to_not enable_service('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def enable_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:service, :enable, resource_name)
    end

    #
    # Assert that a +service+ resource exists in the Chef run with the
    # action +:reload+. Given a Chef Recipe that reloads "apache2" as a
    # +service+:
    #
    #     service 'apache2' do
    #       action :reload
    #     end
    #
    # To test the content rendered by a +service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +service+ resource with ChefSpec.
    #
    # @example Assert that a +service+ was reload
    #   expect(chef_run).to reload_service('apache2')
    #
    # @example Assert that a +service+ was reload with predicate matchers
    #   expect(chef_run).to reload_service('apache2').with_pattern('apa*')
    #
    # @example Assert that a +service+ was reload with attributes
    #   expect(chef_run).to reload_service('apache2').with(pattern: 'apa*')
    #
    # @example Assert that a +service+ was reload using a regex
    #   expect(chef_run).to reload_service('apache2').with(patthen: /(.+)/)
    #
    # @example Assert that a +service+ was _not_ reload
    #   expect(chef_run).to_not reload_service('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def reload_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:service, :reload, resource_name)
    end

    #
    # Assert that a +service+ resource exists in the Chef run with the
    # action +:restart+. Given a Chef Recipe that restarts "apache2" as a
    # +service+:
    #
    #     service 'apache2' do
    #       action :restart
    #     end
    #
    # To test the content rendered by a +service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +service+ resource with ChefSpec.
    #
    # @example Assert that a +service+ was restarted
    #   expect(chef_run).to restart_service('apache2')
    #
    # @example Assert that a +service+ was restarted with predicate matchers
    #   expect(chef_run).to restart_service('apache2').with_pattern('apa*')
    #
    # @example Assert that a +service+ was restarted with attributes
    #   expect(chef_run).to restart_service('apache2').with(pattern: 'apa*')
    #
    # @example Assert that a +service+ was restarted using a regex
    #   expect(chef_run).to restart_service('apache2').with(patthen: /(.+)/)
    #
    # @example Assert that a +service+ was _not_ restarted
    #   expect(chef_run).to_not restart_service('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def restart_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:service, :restart, resource_name)
    end

    #
    # Assert that a +service+ resource exists in the Chef run with the
    # action +:start+. Given a Chef Recipe that starts "apache2" as a
    # +service+:
    #
    #     service 'apache2' do
    #       action :start
    #     end
    #
    # To test the content rendered by a +service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +service+ resource with ChefSpec.
    #
    # @example Assert that a +service+ was started
    #   expect(chef_run).to start_service('apache2')
    #
    # @example Assert that a +service+ was started with predicate matchers
    #   expect(chef_run).to start_service('apache2').with_pattern('apa*')
    #
    # @example Assert that a +service+ was started with attributes
    #   expect(chef_run).to start_service('apache2').with(pattern: 'apa*')
    #
    # @example Assert that a +service+ was started using a regex
    #   expect(chef_run).to start_service('apache2').with(patthen: /(.+)/)
    #
    # @example Assert that a +service+ was _not_ started
    #   expect(chef_run).to_not start_service('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def start_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:service, :start, resource_name)
    end

    #
    # Assert that a +service+ resource exists in the Chef run with the
    # action +:stop+. Given a Chef Recipe that stops "apache2" as a
    # +service+:
    #
    #     service 'apache2' do
    #       action :stop
    #     end
    #
    # To test the content rendered by a +service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +service+ resource with ChefSpec.
    #
    # @example Assert that a +service+ was stopped
    #   expect(chef_run).to stop_service('apache2')
    #
    # @example Assert that a +service+ was stopped with predicate matchers
    #   expect(chef_run).to stop_service('apache2').with_pattern('apa*')
    #
    # @example Assert that a +service+ was stopped with attributes
    #   expect(chef_run).to stop_service('apache2').with(pattern: 'apa*')
    #
    # @example Assert that a +service+ was stopped using a regex
    #   expect(chef_run).to stop_service('apache2').with(patthen: /(.+)/)
    #
    # @example Assert that a +service+ was _not_ stopped
    #   expect(chef_run).to_not stop_service('apache2')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def stop_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:service, :stop, resource_name)
    end
  end
end
