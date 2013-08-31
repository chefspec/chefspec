require 'spec_helper'

module ChefSpec
  module Matchers
    describe :include_recipe do
      let(:matcher) { include_recipe('foo::bar') }

      it 'defines a include_recipe matcher' do
        expect(matcher_defined?(:include_recipe)).to be_true
      end

      it 'matches when the target recipe has been included' do
        expect(matcher).to be_matches({
          node: {
            run_state: { seen_recipes: ['foo::bar'] }
          },
          run_context: { loaded_recipes: ['foo::bar'] }
        })
      end

      it 'does not match when the target recipe has not been included' do
        expect(matcher).to_not be_matches({
          node: {
            run_state: { seen_recipes: ['foo::baz'] }
          },
          run_context: { loaded_recipes: ['foo::baz'] }
        })
      end

    end
  end
end
