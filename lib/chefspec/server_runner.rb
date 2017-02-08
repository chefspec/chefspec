require 'chef/cookbook_loader'
require 'chef/cookbook_uploader'

require_relative 'zero_server'
require_relative 'file_cache_path_proxy'
require_relative 'server_methods'
require_relative 'solo_runner'

module ChefSpec
  class ServerRunner < SoloRunner
    include ChefSpec::ServerMethods

    # @see (SoloRunner#initialize)
    def initialize(options = {})
      # Unlike the SoloRunner, the file_cache_path needs to remain consistent
      # for every Chef run or else the Chef client tries to loads the same
      # cookbook multiple times and will encounter deprecated logic when
      # creating LWRPs. It also slows down the entire process.
      options[:file_cache_path] ||= RSpec.configuration.file_cache_path ||
        ChefSpec::FileCachePathProxy.instance.file_cache_path

      # Call super, but do not pass in the block because we want to customize
      # our yielding.
      super(options, &nil)

      Chef::Config[:client_key]      = client_key
      Chef::Config[:client_name]     = 'chefspec'
      Chef::Config[:node_name]       = 'chefspec'
      Chef::Config[:solo]            = false
      Chef::Config[:solo_legacy_mode] = false

      Chef::Config[:chef_server_url]  = server.url
      Chef::Config[:http_retry_count] = 0

      if policy_mode?
        node.policy_name(options[:policy_name])
        node.policy_group(options[:policy_group] || 'test_group')
        Chef::Config[:policy_group] = node.policy_group
        Chef::Config[:policy_name] = node.policy_name
        # need to reselect policy_builder implementation since we've modified the node
        client.policy_builder.select_implementation(node)
      end

      # Unlike the SoloRunner, the node AND server object are yielded for
      # customization
      yield node, self if block_given?
    end

    def policy_mode?
      @options.key?(:policy_name)
    end

    # @see (SoloRunner#converge)
    def converge(*recipe_names)
      if policy_mode?
        ChefSpec::Policyfile.setup!(node.policy_name, node.policy_group)
        client.policy_builder.send(:implementation).finish_load_node(node)
      else
        ChefSpec::ZeroServer.upload_cookbooks!
      end

      super do
        yield if block_given?

        # Save the node back to the server for searching purposes
        client.register
        node.save
      end
    end

    private

    #
    # The path to the insecure Chef Zero private key on disk. Because Chef
    # requires the path to a file instead of the contents of the key (why),
    # this method dynamically writes the +ChefZero::PRIVATE_KEY+ to disk and
    # then returns that path.
    #
    # @return [String]
    #   the path to the client key on disk
    #
    def client_key
      tmp = Dir.mktmpdir
      path = File.join(tmp, 'client.pem')
      File.open(path, 'wb') { |f| f.write(ChefZero::PRIVATE_KEY) }
      at_exit { FileUtils.rm_rf(tmp) }
      path
    end
  end
end
