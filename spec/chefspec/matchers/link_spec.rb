require 'spec_helper'

module ChefSpec
  module Matchers
    describe :link_to do
      describe "#match" do
        let(:matcher) { link_to('/foo') }
        it "should not match when the link is nil" do
          matcher.matches?(nil).should be false
        end
        it "should not match when the link is different" do
          matcher.matches?({:to => '/bar'}).should be false
        end
        it "should match when the link matches" do
          matcher.matches?({:to => '/foo'}).should be true
        end
      end
    end
  end
end
