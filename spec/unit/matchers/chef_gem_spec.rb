require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_chef_gem)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_chef_gem)  { it_behaves_like 'a resource matcher' }
    describe(:reconfig_chef_gem) { it_behaves_like 'a resource matcher' }
    describe(:remove_chef_gem)   { it_behaves_like 'a resource matcher' }
    describe(:purge_chef_gem)    { it_behaves_like 'a resource matcher' }
  end
end
