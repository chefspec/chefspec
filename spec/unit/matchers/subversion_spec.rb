require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:sync_subversion)         { it_behaves_like 'a resource matcher' }
    describe(:checkout_subversion)     { it_behaves_like 'a resource matcher' }
    describe(:export_subversion)       { it_behaves_like 'a resource matcher' }
    describe(:force_export_subversion) { it_behaves_like 'a resource matcher', :subversion, :force_export }
  end
end
