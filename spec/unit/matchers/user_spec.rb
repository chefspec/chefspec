require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_user) { it_behaves_like 'a resource matcher' }
    describe(:remove_user) { it_behaves_like 'a resource matcher' }
    describe(:modify_user) { it_behaves_like 'a resource matcher' }
    describe(:manage_user) { it_behaves_like 'a resource matcher' }
    describe(:lock_user)   { it_behaves_like 'a resource matcher' }
    describe(:unlock_user) { it_behaves_like 'a resource matcher' }
  end
end
