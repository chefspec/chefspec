module ChefSpec::API
  # @since 0.5.0
  module WindowsServiceMatchers
    ChefSpec.define_matcher :windows_service

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:configure_startup+. Given a Chef Recipe that configures startup for "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :configure_startup
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ had its startup configured
    #   expect(chef_run).to disable_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ had its startup configured with predicate matchers
    #   expect(chef_run).to disable_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ had its startup configured with attributes
    #   expect(chef_run).to disable_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ had its startup configured using a regex
    #   expect(chef_run).to disable_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ did _not_ have its startup configured
    #   expect(chef_run).to_not disable_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def configure_startup_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :configure_startup, resource_name)
    end

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:disable+. Given a Chef Recipe that disables "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :disable
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ was disabled
    #   expect(chef_run).to disable_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ was disabled with predicate matchers
    #   expect(chef_run).to disable_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ was disabled with attributes
    #   expect(chef_run).to disable_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ was disabled using a regex
    #   expect(chef_run).to disable_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ was _not_ disabled
    #   expect(chef_run).to_not disable_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def disable_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :disable, resource_name)
    end

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:enable+. Given a Chef Recipe that enables "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :enable
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ was enabled
    #   expect(chef_run).to enable_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ was enabled with predicate matchers
    #   expect(chef_run).to enable_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ was enabled with attributes
    #   expect(chef_run).to enable_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ was enabled using a regex
    #   expect(chef_run).to enable_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ was _not_ enabled
    #   expect(chef_run).to_not enable_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def enable_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :enable, resource_name)
    end

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:reload+. Given a Chef Recipe that reloads "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :reload
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ was reload
    #   expect(chef_run).to reload_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ was reload with predicate matchers
    #   expect(chef_run).to reload_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ was reload with attributes
    #   expect(chef_run).to reload_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ was reload using a regex
    #   expect(chef_run).to reload_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ was _not_ reload
    #   expect(chef_run).to_not reload_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def reload_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :reload, resource_name)
    end

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:restart+. Given a Chef Recipe that restarts "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :restart
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ was restarted
    #   expect(chef_run).to restart_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ was restarted with predicate matchers
    #   expect(chef_run).to restart_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ was restarted with attributes
    #   expect(chef_run).to restart_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ was restarted using a regex
    #   expect(chef_run).to restart_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ was _not_ restarted
    #   expect(chef_run).to_not restart_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def restart_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :restart, resource_name)
    end

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:start+. Given a Chef Recipe that starts "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :start
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ was started
    #   expect(chef_run).to start_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ was started with predicate matchers
    #   expect(chef_run).to start_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ was started with attributes
    #   expect(chef_run).to start_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ was started using a regex
    #   expect(chef_run).to start_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ was _not_ started
    #   expect(chef_run).to_not start_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def start_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :start, resource_name)
    end

    #
    # Assert that a +windows_service+ resource exists in the Chef run with the
    # action +:stop+. Given a Chef Recipe that stops "BITS" as a
    # +windows_service+:
    #
    #     windows_service 'BITS' do
    #       action :stop
    #     end
    #
    # To test the content rendered by a +windows_service+, see
    # {ChefSpec::API::RenderFileMatchers}.
    #
    # The Examples section demonstrates the different ways to test a
    # +windows_service+ resource with ChefSpec.
    #
    # @example Assert that a +windows_service+ was stopped
    #   expect(chef_run).to stop_windows_service('BITS')
    #
    # @example Assert that a +windows_service+ was stopped with predicate matchers
    #   expect(chef_run).to stop_windows_service('BITS').with_pattern('BI*')
    #
    # @example Assert that a +windows_service+ was stopped with attributes
    #   expect(chef_run).to stop_windows_service('BITS').with(pattern: 'BI*')
    #
    # @example Assert that a +windows_service+ was stopped using a regex
    #   expect(chef_run).to stop_windows_service('BITS').with(pattern: /(.+)/)
    #
    # @example Assert that a +windows_service+ was _not_ stopped
    #   expect(chef_run).to_not stop_windows_service('BITS')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def stop_windows_service(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:windows_service, :stop, resource_name)
    end
  end
end
