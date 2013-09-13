require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_gem_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_gem_package)  { it_behaves_like 'a resource matcher' }
    describe(:reconfig_gem_package) { it_behaves_like 'a resource matcher' }
    describe(:remove_gem_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_gem_package)    { it_behaves_like 'a resource matcher' }
  end
end
