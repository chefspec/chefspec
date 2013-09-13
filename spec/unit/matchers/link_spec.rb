require 'spec_helper'

module ChefSpec
  module Matchers
    describe(:create_link) { it_behaves_like 'a resource matcher' }
    describe(:delete_link) { it_behaves_like 'a resource matcher' }

    describe :link_to do
      let(:matcher) { link_to('/foo') }

      it 'does not match when the link is nil' do
        expect(matcher).to_not be_matches(nil)
      end

      it 'does not match when the link is different' do
        expect(matcher).to_not be_matches({ to: '/bar' })
      end

      it 'matches when the link matches' do
        expect(matcher).to be_matches(double(to: '/foo', is_a?: true))
      end
    end
  end
end
