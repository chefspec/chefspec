require 'spec_helper'

module ChefSpec
  module Matchers
    describe :ruby_block do
      context 'with String expectations' do
        let(:matcher) { execute_ruby_block('sample') }

        it 'does not match when no resources exists' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'matches when ruby_block resource exists' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'ruby_block',
              name: 'sample',
              action: :create
            }]
          })
        end

        it 'does not match when the ruby_block resource with another name exists' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'ruby_block',
              name: 'not_sample',
              action: :create
            }]
          })
        end
      end

      context 'with Regexp expectations' do
        let(:matcher) { execute_ruby_block(/sample/) }

        it 'does not match when no resources exists' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'matches when an exact matching ruby_block resource exists' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'ruby_block',
              name: 'sample',
              action: :create
            }]
          })
        end

        it 'matches when a matching ruby_block resource exists' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: 'ruby_block',
              name: 'still_sample',
              action: :create
            }]
          })
        end

        it 'does not match when the ruby_block resource with a non-matching name exists' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'ruby_block',
              name: 'different',
              action: :create
            }]
          })
        end
      end
    end
  end
end
