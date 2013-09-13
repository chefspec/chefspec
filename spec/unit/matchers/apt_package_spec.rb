require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_apt_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_apt_package)  { it_behaves_like 'a resource matcher' }
    describe(:reconfig_apt_package) { it_behaves_like 'a resource matcher' }
    describe(:remove_apt_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_apt_package)    { it_behaves_like 'a resource matcher' }
  end
end
