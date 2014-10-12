module ChefSpec::API
  # @since 3.0.0
  module MountMatchers
    ChefSpec.define_matcher :mount

    #
    # Assert that a +mount+ resource exists in the Chef run with the
    # action +:disable+. Given a Chef Recipe that disables "/mnt/volume1" as a
    # +mount+:
    #
    #     mount '/mnt/volume1' do
    #       action :disable
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mount+ resource with ChefSpec.
    #
    # @example Assert that a +mount+ was disableed
    #   expect(chef_run).to disable_mount('/mnt/volume1')
    #
    # @example Assert that a +mount+ was disableed with predicate matchers
    #   expect(chef_run).to disable_mount('/mnt/volume1').with_pass(4)
    #
    # @example Assert that a +mount+ was disableed with attributes
    #   expect(chef_run).to disable_mount('/mnt/volume1').with(pass: 4)
    #
    # @example Assert that a +mount+ was disableed using a regex
    #   expect(chef_run).to disable_mount('/mnt/volume1').with(pass: /\d+/)
    #
    # @example Assert that a +mount+ was _not_ disableed
    #   expect(chef_run).to_not disable_mount('/mnt/volume1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def disable_mount(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mount, :disable, resource_name)
    end

    #
    # Assert that a +mount+ resource exists in the Chef run with the
    # action +:enable+. Given a Chef Recipe that enables "/mnt/volume1" as a
    # +mount+:
    #
    #     mount '/mnt/volume1' do
    #       action :enable
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mount+ resource with ChefSpec.
    #
    # @example Assert that a +mount+ was enabled
    #   expect(chef_run).to enable_mount('/mnt/volume1')
    #
    # @example Assert that a +mount+ was enabled with predicate matchers
    #   expect(chef_run).to enable_mount('/mnt/volume1').with_pass(4)
    #
    # @example Assert that a +mount+ was enabled with attributes
    #   expect(chef_run).to enable_mount('/mnt/volume1').with(pass: 4)
    #
    # @example Assert that a +mount+ was enabled using a regex
    #   expect(chef_run).to enable_mount('/mnt/volume1').with(pass: /\d+/)
    #
    # @example Assert that a +mount+ was _not_ enabled
    #   expect(chef_run).to_not enable_mount('/mnt/volume1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def enable_mount(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mount, :enable, resource_name)
    end

    #
    # Assert that a +mount+ resource exists in the Chef run with the
    # action +:mount+. Given a Chef Recipe that mounts "/mnt/volume1" as a
    # +mount+:
    #
    #     mount '/mnt/volume1' do
    #       action :mount
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mount+ resource with ChefSpec.
    #
    # @example Assert that a +mount+ was mounted
    #   expect(chef_run).to mount_mount('/mnt/volume1')
    #
    # @example Assert that a +mount+ was mounted with predicate matchers
    #   expect(chef_run).to mount_mount('/mnt/volume1').with_pass(4)
    #
    # @example Assert that a +mount+ was mounted with attributes
    #   expect(chef_run).to mount_mount('/mnt/volume1').with(pass: 4)
    #
    # @example Assert that a +mount+ was mounted using a regex
    #   expect(chef_run).to mount_mount('/mnt/volume1').with(pass: /\d+/)
    #
    # @example Assert that a +mount+ was _not_ mounted
    #   expect(chef_run).to_not mount_mount('/mnt/volume1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def mount_mount(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mount, :mount, resource_name)
    end

    #
    # Assert that a +mount+ resource exists in the Chef run with the
    # action +:remount+. Given a Chef Recipe that remounts "/mnt/volume1" as a
    # +mount+:
    #
    #     mount '/mnt/volume1' do
    #       action :remount
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mount+ resource with ChefSpec.
    #
    # @example Assert that a +mount+ was remounted
    #   expect(chef_run).to remount_mount('/mnt/volume1')
    #
    # @example Assert that a +mount+ was remounted with predicate matchers
    #   expect(chef_run).to remount_mount('/mnt/volume1').with_pass(4)
    #
    # @example Assert that a +mount+ was remounted with attributes
    #   expect(chef_run).to remount_mount('/mnt/volume1').with(pass: 4)
    #
    # @example Assert that a +mount+ was remounted using a regex
    #   expect(chef_run).to remount_mount('/mnt/volume1').with(pass: /\d+/)
    #
    # @example Assert that a +mount+ was _not_ remounted
    #   expect(chef_run).to_not remount_mount('/mnt/volume1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def remount_mount(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mount, :remount, resource_name)
    end

    #
    # Assert that a +mount+ resource exists in the Chef run with the
    # action +:umount+. Given a Chef Recipe that umounts "/mnt/volume1" as a
    # +mount+:
    #
    #     mount '/mnt/volume1' do
    #       action :umount
    #     end
    #
    # The Examples section demonstrates the different ways to test a
    # +mount+ resource with ChefSpec.
    #
    # @example Assert that a +mount+ was umounted
    #   expect(chef_run).to umount_mount('/mnt/volume1')
    #
    # @example Assert that a +mount+ was umounted with predicate matchers
    #   expect(chef_run).to umount_mount('/mnt/volume1').with_pass(4)
    #
    # @example Assert that a +mount+ was umounted with attributes
    #   expect(chef_run).to umount_mount('/mnt/volume1').with(pass: 4)
    #
    # @example Assert that a +mount+ was umounted using a regex
    #   expect(chef_run).to umount_mount('/mnt/volume1').with(pass: /\d+/)
    #
    # @example Assert that a +mount+ was _not_ umounted
    #   expect(chef_run).to_not umount_mount('/mnt/volume1')
    #
    #
    # @param [String, Regex] resource_name
    #   the name of the resource to match
    #
    # @return [ChefSpec::Matchers::ResourceMatcher]
    #
    def umount_mount(resource_name)
      ChefSpec::Matchers::ResourceMatcher.new(:mount, :umount, resource_name)
    end

  end
end
