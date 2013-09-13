require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:run_powershell_script) { it_behaves_like 'a resource matcher' }
  end
end
