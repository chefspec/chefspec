module ChefSpec::API
  # @since 3.0.0
  module MdadmMatchers
    ChefSpec.define_matcher :mdadm

    #
    # Assert that a +mdadm+ resource exists in the Chef run with the
    # action +:assemble+. Given a Chef Recipe that assembles "/dev/md0" as a
    # +mdadm+:
    #
    #     mdadm '/dev/md0' do
    #       action :assemble
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mdadm+ resource with ChefSpec.
    #
    # @example Assert that a +mdadm+ was assembled
    #   expect(chef_run).to assemble_mdadm('/dev/md0')
    #
    # @example Assert that a +mdadm+ was assembled with predicate matchers
    #   expect(chef_run).to assemble_mdadm('/dev/md0').with_devices(['/dev/sda'])
    #
    # @example Assert that a +mdadm+ was assembled with attributes
    #   expect(chef_run).to assemble_mdadm('/dev/md0').with(devices: ['/dev/sda'])
    #
    # @example Assert that a +mdadm+ was assembled using a regex
    #   expect(chef_run).to assemble_mdadm('/dev/md0').with(devices: '/dev/sda')
    #
    # @example Assert that a +mdadm+ was _not_ assembled
    #   expect(chef_run).to_not assemble_mdadm('/dev/md0')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def assemble_mdadm(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mdadm, :assemble, resource_name)
    end

    #
    # Assert that a +mdadm+ resource exists in the Chef run with the
    # action +:create+. Given a Chef Recipe that creates "/dev/md0" as a
    # +mdadm+:
    #
    #     mdadm '/dev/md0' do
    #       action :create
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mdadm+ resource with ChefSpec.
    #
    # @example Assert that a +mdadm+ was created
    #   expect(chef_run).to create_mdadm('/dev/md0')
    #
    # @example Assert that a +mdadm+ was created with predicate matchers
    #   expect(chef_run).to create_mdadm('/dev/md0').with_devices(['/dev/sda'])
    #
    # @example Assert that a +mdadm+ was created with attributes
    #   expect(chef_run).to create_mdadm('/dev/md0').with(devices: ['/dev/sda'])
    #
    # @example Assert that a +mdadm+ was created using a regex
    #   expect(chef_run).to create_mdadm('/dev/md0').with(devices: '/dev/sda')
    #
    # @example Assert that a +mdadm+ was _not_ created
    #   expect(chef_run).to_not create_mdadm('/dev/md0')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def create_mdadm(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mdadm, :create, resource_name)
    end

    #
    # Assert that a +mdadm+ resource exists in the Chef run with the
    # action +:stop+. Given a Chef Recipe that stops "/dev/md0" as a
    # +mdadm+:
    #
    #     mdadm '/dev/md0' do
    #       action :stop
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mdadm+ resource with ChefSpec.
    #
    # @example Assert that a +mdadm+ was stopped
    #   expect(chef_run).to stop_mdadm('/dev/md0')
    #
    # @example Assert that a +mdadm+ was stopped with predicate matchers
    #   expect(chef_run).to stop_mdadm('/dev/md0').with_devices(['/dev/sda'])
    #
    # @example Assert that a +mdadm+ was stopped with attributes
    #   expect(chef_run).to stop_mdadm('/dev/md0').with(devices: ['/dev/sda'])
    #
    # @example Assert that a +mdadm+ was stopped using a regex
    #   expect(chef_run).to stop_mdadm('/dev/md0').with(devices: '/dev/sda')
    #
    # @example Assert that a +mdadm+ was _not_ stopped
    #   expect(chef_run).to_not stop_mdadm('/dev/md0')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def stop_mdadm(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mdadm, :stop, resource_name)
    end
  end
end
