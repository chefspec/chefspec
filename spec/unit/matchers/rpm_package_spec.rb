require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_rpm_package)  { it_behaves_like 'a resource matcher' }
    describe(:upgrade_rpm_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_rpm_package)   { it_behaves_like 'a resource matcher' }
  end
end
