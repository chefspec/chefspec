require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_yum_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_yum_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_yum_package)   { it_behaves_like 'a resource matcher' }
    describe(:purge_yum_package)    { it_behaves_like 'a resource matcher' }
  end
end
