module ChefSpec::API
  # @since 5.1.0
  module SystemdUnitMatchers
    ChefSpec.define_matcher :systemd_unit

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was created
    #   expect(chef_run).to create_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ created
    #   expect(chef_run).to_not create_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def create_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :create, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was deleted
    #   expect(chef_run).to delete_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ deleted
    #   expect(chef_run).to_not delete_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def delete_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :delete, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:enable+. Given a Chef Recipe that enables the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :enables
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was enabled
    #   expect(chef_run).to enable_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ enabled
    #   expect(chef_run).to_not enable_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def enable_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :enable, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:disable+. Given a Chef Recipe that disables the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :disable
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was disabled
    #   expect(chef_run).to disable_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ disabled
    #   expect(chef_run).to_not disable_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def disable_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :disable, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:mask+. Given a Chef Recipe that masks the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :mask
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was masked
    #   expect(chef_run).to mask_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ masked
    #   expect(chef_run).to_not mask_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def mask_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :mask, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:unmask+. Given a Chef Recipe that masks the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :unmask
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was unmasked
    #   expect(chef_run).to unmask_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ unmasked
    #   expect(chef_run).to_not unmask_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def unmask_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :unmask, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:start+. Given a Chef Recipe that starts the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :start
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was started
    #   expect(chef_run).to start_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ started
    #   expect(chef_run).to_not start_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def start_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :start, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:stop+. Given a Chef Recipe that stops the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :stop
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was stopped
    #   expect(chef_run).to stop_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ stopped
    #   expect(chef_run).to_not stop_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def stop_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :stop, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:restart+. Given a Chef Recipe that restarts the systemd_unit
    # "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :restart
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was restarted
    #   expect(chef_run).to restart_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ restarted
    #   expect(chef_run).to_not restart_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def restart_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :restart, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:try_restart+. Given a Chef Recipe that tries to restarts the
    # systemd_unit "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :try_restart
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was try_restart'd
    #   expect(chef_run).to try_restart_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ try_restart'd
    #   expect(chef_run).to_not try_restart_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def try_restart_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :try_restart, resource_name)
    end

    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:reload_or_restart+. Given a Chef Recipe that reloads or restarts
    # the systemd_unit "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :reload_or_restart
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was reloaded or restarted
    #   expect(chef_run).to reload_or_restart_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ reloaded or restarted
    #   expect(chef_run).to_not reload_or_restart_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def reload_or_restart_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :reload_or_restart, resource_name)
    end
    #
    # Assert that a +systemd_unit+ resource exists in the Chef run with the
    # action +:reload_or_try_restart+. Given a Chef Recipe that reloads or attempts
    # to restart the systemd_unit "sysstat-collect.timer":
    #
    #     systemd_unit 'sysstat-collect.timer' do
    #       action :reload_or_try_restart
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +systemd_unit+ resource with ChefSpec.
    #
    # @example Assert that a +systemd_unit+ was reloaded or try restarted
    #   expect(chef_run).to reload_or_try_restart_systemd_unit('sysstat-collect.timer')
    #
    # @example Assert that a +systemd_unit+ was _not_ reloaded or try restarted
    #   expect(chef_run).to_not reload_or_try_restart_systemd_unit('sysstat-collect.timer')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #

    def reload_or_try_restart_systemd_unit(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:systemd_unit, :reload_or_try_restart, resource_name)
    end
  end
end
