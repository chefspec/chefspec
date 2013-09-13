require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:run_bash)   { it_behaves_like 'a resource matcher' }
    describe(:run_csh)    { it_behaves_like 'a resource matcher' }
    describe(:run_perl)   { it_behaves_like 'a resource matcher' }
    describe(:run_python) { it_behaves_like 'a resource matcher' }
    describe(:run_ruby)   { it_behaves_like 'a resource matcher' }
    describe(:run_script) { it_behaves_like 'a resource matcher' }
  end
end
