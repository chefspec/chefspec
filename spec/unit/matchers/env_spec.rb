require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_env) { it_behaves_like 'a resource matcher' }
    describe(:delete_env) { it_behaves_like 'a resource matcher' }
    describe(:modify_env) { it_behaves_like 'a resource matcher' }
  end
end
