require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:install_solaris_package)  { it_behaves_like 'a resource matcher' }
    describe(:remove_solaris_package)   { it_behaves_like 'a resource matcher' }
  end
end
