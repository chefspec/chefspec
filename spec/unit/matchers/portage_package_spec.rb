require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_portage_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_portage_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_portage_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_portage_package)    { it_behaves_like 'a resource matcher' }
  end
end
