require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:sync_scm)         { it_behaves_like 'a resource matcher' }
    describe(:checkout_scm)     { it_behaves_like 'a resource matcher' }
    describe(:export_scm)       { it_behaves_like 'a resource matcher' }
  end
end
