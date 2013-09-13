require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:add_route)    { it_behaves_like 'a resource matcher' }
    describe(:delete_route) { it_behaves_like 'a resource matcher' }
  end
end
