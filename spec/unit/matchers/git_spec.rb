require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:sync_git)     { it_behaves_like 'a resource matcher' }
    describe(:checkout_git) { it_behaves_like 'a resource matcher' }
    describe(:export_git)   { it_behaves_like 'a resource matcher' }
  end
end
