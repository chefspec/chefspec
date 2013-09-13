require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_freebsd_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_freebsd_package)   { it_behaves_like 'a resource matcher' }
  end
end
