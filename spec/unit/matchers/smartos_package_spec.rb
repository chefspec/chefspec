require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_smartos_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_smartos_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_smartos_package)   { it_behaves_like 'a resource matcher' }
  end
end
