require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_dpkg_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_dpkg_package)  { it_behaves_like 'a resource matcher' }
    describe(:reconfig_dpkg_package) { it_behaves_like 'a resource matcher' }
    describe(:remove_dpkg_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_dpkg_package)    { it_behaves_like 'a resource matcher' }
  end
end
