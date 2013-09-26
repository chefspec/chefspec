require_relative 'runner'

module ChefSpec
  module Matchers
    #
    # Define simple RSpec matchers for the product of resource types and actions
    #
    # @param [Array] actions
    #   The valid actions - for example [:create, :delete]
    # @param [Array] resource_types
    #   The resource names
    #
    def self.define_resource_matchers(actions, resource_types)
      actions.product(resource_types).flatten.each_slice(2) do |action, resource_type|
        # Define a shortcut method on the Chef Runner
        define_runner_method(resource_type)

        # Mutate create_if_missing_file #=> create_file_if_missing
        matcher_name = action == :create_if_missing ? "#{action.to_s.gsub('_if_missing', '')}_#{resource_type}_if_missing" : "#{action}_#{resource_type}"

        RSpec::Matchers.define matcher_name.to_sym do |name|
          match do |chef_run|
            chef_run.resources.any? do |_, resource|
              if resource_type == resource.resource_name.to_sym &&
                 (name === resource.identity || name === resource.name) &&
                 Array(resource.action).map(&:to_sym).include?(action) &&
                 expected_attributes?(resource)

                 @resource_name = resource.identity
                 true
              else
                false
              end
            end
          end

          chain(:with) do |attributes|
            @attributes = attributes
          end

          failure_message_for_should do |actual|
            "expected '#{resource_type}[#{name}]' with action ':#{action}' to be in Chef run"
          end

          failure_message_for_should_not do |actual|
            "expected '#{resource_type}[#{@resource_name || name}]' matching '#{name}' with action ':#{action}' to not be in Chef run"
          end

          def expected_attributes?(resource)
            (@attributes || {}).all? do |k, v|
              # Chef 11+ stores the source attribute internally as an array since
              # in order to support mirrors.
              if k == :source
                Array(v) == Array(resource.send(k))
              else
                v  === resource.send(k)
              end
            end
          end
        end
      end
    end

    #
    # Define a method on the ChefSpec::Runner for quick access to
    # find a resource.
    #
    # @example find a template
    #   chef_run.template('/etc/thing')
    #
    # @param [String] resource_type
    #   the type of resource (template, file)
    #
    def self.define_runner_method(resource_type)
      ChefSpec::Runner.send(:define_method, resource_type) do |name|
        find_resource(resource_type, name)
      end
    end
  end
end

require_relative 'matchers/apt_package'
require_relative 'matchers/batch'
require_relative 'matchers/chef_gem'
require_relative 'matchers/cookbook_file'
require_relative 'matchers/cron'
require_relative 'matchers/deploy'
require_relative 'matchers/directory'
require_relative 'matchers/dpkg_package'
require_relative 'matchers/easy_install_package'
require_relative 'matchers/env'
require_relative 'matchers/erl_call'
require_relative 'matchers/execute'
require_relative 'matchers/file'
require_relative 'matchers/freebsd_package'
require_relative 'matchers/gem_package'
require_relative 'matchers/git'
require_relative 'matchers/group'
require_relative 'matchers/http_request'
require_relative 'matchers/ifconfig'
require_relative 'matchers/include_recipe'
require_relative 'matchers/ips_package'
require_relative 'matchers/link'
require_relative 'matchers/log'
require_relative 'matchers/macports_package'
require_relative 'matchers/mdadm'
require_relative 'matchers/mount'
require_relative 'matchers/notifications'
require_relative 'matchers/ohai'
require_relative 'matchers/package'
require_relative 'matchers/pacman_package'
require_relative 'matchers/portage_package'
require_relative 'matchers/powershell_script'
require_relative 'matchers/registry_key'
require_relative 'matchers/remote_directory'
require_relative 'matchers/remote_file'
require_relative 'matchers/render_file'
require_relative 'matchers/route'
require_relative 'matchers/rpm_package'
require_relative 'matchers/ruby_block'
require_relative 'matchers/scm'
require_relative 'matchers/script'
require_relative 'matchers/service'
require_relative 'matchers/smartos_package'
require_relative 'matchers/solaris_package'
require_relative 'matchers/subversion'
require_relative 'matchers/template'
require_relative 'matchers/user'
require_relative 'matchers/yum_package'
