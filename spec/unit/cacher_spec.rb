require 'spec_helper'
require 'chefspec/cacher'

describe ChefSpec::Cacher do
  let(:klass) do
    Class.new(RSpec::Core::ExampleGroup) do
      extend ChefSpec::Cacher

      def self.metadata
        { parent_example_group: { location: 'spec' } }
      end
    end
  end

  let(:cache) { described_class.class_variable_get(:@@cache) }
  let(:preserve_cache) { false }

  before(:each) { described_class.class_variable_set(:@@cache, {}) unless preserve_cache }

  describe 'cached' do
    it 'lazily defines the results for the cache' do
      klass.cached(:chef_run)
      expect(klass).to be_method_defined(:chef_run)
    end

    it 'adds the item to the cache when called' do
      runner = double(:runner)
      klass.cached(:chef_run) { runner }
      klass.new.chef_run

      expect(cache[Thread.current.object_id]).to have_key('spec.chef_run')
      expect(cache[Thread.current.object_id]['spec.chef_run']).to eq(runner)
    end

    context 'when multithreaded environment' do
      it 'is thread safe' do
        (1..2).each do |n|
          Thread.new do
            klass.cached(:chef_run) { n }
            expect(klass.new.chef_run).to eq(n)
          end.join
        end
      end
    end

    context 'when example groups are defined by looping' do
      let(:preserve_cache) { true }

      ['first', 'second', 'third'].each do |iteration|
        context "on the #{iteration} iteration" do
          context 'in caching context' do
            cached(:cached_iteration) { iteration }
            it 'caches the iteration for this context' do
              expect(cached_iteration).to eq iteration
            end
          end
        end
      end
    end
  end

  describe 'cached!' do
    it 'loads the value at runtime' do
      expect(klass).to receive(:cached).with(:chef_run).once
      expect(klass).to receive(:before).once

      klass.cached!(:chef_run) { }
    end
  end
end
