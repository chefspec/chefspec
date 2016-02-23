module ChefSpec
  module API
    extend self

    def self.included(base)
      submodules.each do |child|
        base.send(:include, child)
      end
    end

    private

    #
    # WARNING: This is metaprogramming madness. Find all modules who are
    # nested beneath this module.
    #
    # @return [Array<Module>]
    #
    def submodules
      self.constants
        .map { |name| const_get(name) }
        .select { |const| const.class == Module }
    end
  end
end

require_relative 'api/apt_package'
require_relative 'api/batch'
require_relative 'api/chef_gem'
require_relative 'api/chocolatey_package'
require_relative 'api/cookbook_file'
require_relative 'api/cron'
require_relative 'api/deploy'
require_relative 'api/directory'
require_relative 'api/dpkg_package'
require_relative 'api/do_nothing'
require_relative 'api/dsc_resource'
require_relative 'api/easy_install_package'
require_relative 'api/env'
require_relative 'api/erl_call'
require_relative 'api/execute'
require_relative 'api/file'
require_relative 'api/freebsd_package'
require_relative 'api/gem_package'
require_relative 'api/git'
require_relative 'api/group'
require_relative 'api/http_request'
require_relative 'api/ifconfig'
require_relative 'api/include_recipe'
require_relative 'api/ips_package'
require_relative 'api/link'
require_relative 'api/log'
require_relative 'api/macports_package'
require_relative 'api/mdadm'
require_relative 'api/mount'
require_relative 'api/notifications'
require_relative 'api/ohai'
require_relative 'api/package'
require_relative 'api/pacman_package'
require_relative 'api/portage_package'
require_relative 'api/powershell_script'
require_relative 'api/reboot'
require_relative 'api/registry_key'
require_relative 'api/remote_directory'
require_relative 'api/remote_file'
require_relative 'api/render_file'
require_relative 'api/route'
require_relative 'api/rpm_package'
require_relative 'api/ruby_block'
require_relative 'api/script'
require_relative 'api/service'
require_relative 'api/smartos_package'
require_relative 'api/solaris_package'
require_relative 'api/state_attrs'
require_relative 'api/subscriptions'
require_relative 'api/subversion'
require_relative 'api/template'
require_relative 'api/user'
require_relative 'api/windows_package'
require_relative 'api/windows_service'
require_relative 'api/yum_package'
