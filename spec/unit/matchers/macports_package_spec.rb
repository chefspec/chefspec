require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_macports_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_macports_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_macports_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_macports_package)   { it_behaves_like 'a resource matcher' }
  end
end
