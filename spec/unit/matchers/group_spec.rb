require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_group) { it_behaves_like 'a resource matcher' }
    describe(:remove_group) { it_behaves_like 'a resource matcher' }
    describe(:modify_group) { it_behaves_like 'a resource matcher' }
    describe(:manage_group) { it_behaves_like 'a resource matcher' }
  end
end
