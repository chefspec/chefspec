require 'rspec'

module ChefSpec::Extensions
  module Chef
  end
end

# STOP! DO NOT ALPHABETIZE!
require_relative 'extensions/chef/resource'  # must come before client extensions or anything that winds up loading resources
require_relative 'extensions/chef/securable'
require_relative 'extensions/chef/client'
require_relative 'extensions/chef/conditional'
require_relative 'extensions/chef/cookbook_uploader'
require_relative 'extensions/chef/cookbook/gem_installer'
require_relative 'extensions/chef/data_query'
require_relative 'extensions/chef/lwrp_base'
require_relative 'extensions/chef/resource/freebsd_package'
