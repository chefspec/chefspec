require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:add_ifconfig)     { it_behaves_like 'a resource matcher' }
    describe(:delete_ifconfig)  { it_behaves_like 'a resource matcher' }
    describe(:enable_ifconfig)  { it_behaves_like 'a resource matcher' }
    describe(:disable_ifconfig) { it_behaves_like 'a resource matcher' }
  end
end
