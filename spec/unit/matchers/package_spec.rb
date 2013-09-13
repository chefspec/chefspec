require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_package)  { it_behaves_like 'a resource matcher' }
    describe(:reconfig_package) { it_behaves_like 'a resource matcher' }
    describe(:remove_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_package)    { it_behaves_like 'a resource matcher' }
  end
end
