require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:get_http_request)     { it_behaves_like 'a resource matcher' }
    describe(:put_http_request)     { it_behaves_like 'a resource matcher' }
    describe(:post_http_request)    { it_behaves_like 'a resource matcher' }
    describe(:delete_http_request)  { it_behaves_like 'a resource matcher' }
    describe(:head_http_request)    { it_behaves_like 'a resource matcher' }
    describe(:options_http_request) { it_behaves_like 'a resource matcher' }
  end
end
