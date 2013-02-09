require 'spec_helper'

module ChefSpec
  module Matchers

    describe :include_recipe do

      let(:matcher){ include_recipe "foo::bar"}

      it "should define a include_recipe matcher" do
        matcher_defined?(:include_recipe).should be_true
      end

      it "should match when the target recipe has been included" do
        matcher.matches?({
          :run_context => {
            :loaded_recipe? => true
          }
        }).should be_true
      end

      it "should not match when the target recipe has not been included" do
        matcher.matches?({
          :run_context => {
            :loaded_recipe? => false
          }
        }).should be_false
      end

    end
  end
end
