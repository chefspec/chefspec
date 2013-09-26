require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_mdadm) { it_behaves_like 'a resource matcher' }
    describe(:assemble_mdadm) { it_behaves_like 'a resource matcher' }
    describe(:stop_mdadm) { it_behaves_like 'a resource matcher' }
  end
end
