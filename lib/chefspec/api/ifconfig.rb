module ChefSpec::API
  # @since 3.0.0
  module IfconfigMatchers
    ChefSpec.define_matcher :ifconfig

    #
    # Assert that an +ifconfig+ resource exists in the Chef run with the
    # action +:add+. Given a Chef Recipe that adds "10.0.0.1" as an
    # +ifconfig+:
    #
    #     ifconfig '10.0.0.1' do
    #       action :add
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +ifconfig+ resource with ChefSpec.
    #
    # @example Assert that an +ifconfig+ was added
    #   expect(chef_run).to add_ifconfig('10.0.0.1')
    #
    # @example Assert that an +ifconfig+ was added with predicate matchers
    #   expect(chef_run).to add_ifconfig('10.0.0.1').with_device('eth0')
    #
    # @example Assert that an +ifconfig+ was added with attributes
    #   expect(chef_run).to add_ifconfig('10.0.0.1').with(device: 'eth0')
    #
    # @example Assert that an +ifconfig+ was added using a regex
    #   expect(chef_run).to add_ifconfig('10.0.0.1').with(device: /eth(\d+)/)
    #
    # @example Assert that an +ifconfig+ was _not_ added
    #   expect(chef_run).to_not add_ifconfig('10.0.0.1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def add_ifconfig(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ifconfig, :add, resource_name)
    end

    #
    # Assert that an +ifconfig+ resource exists in the Chef run with the
    # action +:delete+. Given a Chef Recipe that deletes "10.0.0.1" as an
    # +ifconfig+:
    #
    #     ifconfig '10.0.0.1' do
    #       action :delete
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +ifconfig+ resource with ChefSpec.
    #
    # @example Assert that an +ifconfig+ was deleted
    #   expect(chef_run).to delete_ifconfig('10.0.0.1')
    #
    # @example Assert that an +ifconfig+ was deleted with predicate matchers
    #   expect(chef_run).to delete_ifconfig('10.0.0.1').with_device('eth0')
    #
    # @example Assert that an +ifconfig+ was deleted with attributes
    #   expect(chef_run).to delete_ifconfig('10.0.0.1').with(device: 'eth0')
    #
    # @example Assert that an +ifconfig+ was deleted using a regex
    #   expect(chef_run).to delete_ifconfig('10.0.0.1').with(device: /eth(\d+)/)
    #
    # @example Assert that an +ifconfig+ was _not_ deleted
    #   expect(chef_run).to_not delete_ifconfig('10.0.0.1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def delete_ifconfig(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ifconfig, :delete, resource_name)
    end

    #
    # Assert that an +ifconfig+ resource exists in the Chef run with the
    # action +:disable+. Given a Chef Recipe that disables "10.0.0.1" as an
    # +ifconfig+:
    #
    #     ifconfig '10.0.0.1' do
    #       action :disable
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +ifconfig+ resource with ChefSpec.
    #
    # @example Assert that an +ifconfig+ was disabled
    #   expect(chef_run).to disable_ifconfig('10.0.0.1')
    #
    # @example Assert that an +ifconfig+ was disabled with predicate matchers
    #   expect(chef_run).to disable_ifconfig('10.0.0.1').with_device('eth0')
    #
    # @example Assert that an +ifconfig+ was disabled with attributes
    #   expect(chef_run).to disable_ifconfig('10.0.0.1').with(device: 'eth0')
    #
    # @example Assert that an +ifconfig+ was disabled using a regex
    #   expect(chef_run).to disable_ifconfig('10.0.0.1').with(device: /eth(\d+)/)
    #
    # @example Assert that an +ifconfig+ was _not_ disabled
    #   expect(chef_run).to_not disable_ifconfig('10.0.0.1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def disable_ifconfig(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ifconfig, :disable, resource_name)
    end

    #
    # Assert that an +ifconfig+ resource exists in the Chef run with the
    # action +:enable+. Given a Chef Recipe that enables "10.0.0.1" as an
    # +ifconfig+:
    #
    #     ifconfig '10.0.0.1' do
    #       action :enable
    #     end
    #
    # The Examples section demonstrates the different ways to test an
    # +ifconfig+ resource with ChefSpec.
    #
    # @example Assert that an +ifconfig+ was enabled
    #   expect(chef_run).to enable_ifconfig('10.0.0.1')
    #
    # @example Assert that an +ifconfig+ was enabled with predicate matchers
    #   expect(chef_run).to enable_ifconfig('10.0.0.1').with_device('eth0')
    #
    # @example Assert that an +ifconfig+ was enabled with attributes
    #   expect(chef_run).to enable_ifconfig('10.0.0.1').with(device: 'eth0')
    #
    # @example Assert that an +ifconfig+ was enabled using a regex
    #   expect(chef_run).to enable_ifconfig('10.0.0.1').with(device: /eth(\d+)/)
    #
    # @example Assert that an +ifconfig+ was _not_ enabled
    #   expect(chef_run).to_not enable_ifconfig('10.0.0.1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def enable_ifconfig(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:ifconfig, :enable, resource_name)
    end
  end
end
