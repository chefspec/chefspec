require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_easy_install_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_easy_install_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_easy_install_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_easy_install_package)    { it_behaves_like 'a resource matcher' }
  end
end
