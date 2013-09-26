require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:run_batch) { it_behaves_like 'a resource matcher' }
  end
end
