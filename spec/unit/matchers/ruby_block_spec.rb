require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:run_ruby_block) { it_behaves_like 'a resource matcher' }
  end
end
