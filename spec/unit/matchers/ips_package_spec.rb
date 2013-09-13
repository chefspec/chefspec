require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_ips_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_ips_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_ips_package)   { it_behaves_like 'a resource matcher' }
  end
end
