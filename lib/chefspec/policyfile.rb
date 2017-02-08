begin
  require 'chef-dk/policyfile_services/export_repo'
  require 'chef-dk/policyfile_services/install'
  require 'chef-dk/policyfile_services/push'
rescue LoadError
  raise ChefSpec::Error::GemLoadError.new(gem: 'chef-dk', name: 'ChefDK')
end

module ChefSpec
  class Policyfile
    class << self
      extend Forwardable
      def_delegators :instance, :setup!, :teardown!
    end

    include Singleton
    #
    # Setup and install the necessary  dependencies in the temporary directory
    #
    def setup!(policy_name = 'Policyfile', policy_group = 'test_group')
      policy_base_path = RSpec.configuration.policy_path
      policyfile_path = File.join(policy_base_path, policy_name + '.rb')

      installer = ChefDK::PolicyfileServices::Install.new(
        policyfile: policyfile_path,
        ui: ChefDK::UI.null
      )
      installer.run

      pusher = ChefDK::PolicyfileServices::Push.new(
        policyfile: policyfile_path,
        ui: ChefDK::UI.null,
        policy_group: policy_group,
        config: Chef::Config
      )
      pusher.run
    end
  end
end

RSpec.configure do |config|
#  config.before(:suite) { ChefSpec::Policyfile.setup! }
end
