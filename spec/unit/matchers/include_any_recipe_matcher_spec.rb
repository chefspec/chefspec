require 'spec_helper'

describe ChefSpec::Matchers::IncludeAnyRecipeMatcher do
  let(:node) { double('Chef::Node', run_list: run_list) }
  let(:run_list) { double('Chef::RunList', run_list_items: run_list_items) }
  let(:run_list_items) { [run_list_item_one] }
  let(:run_list_item_one) { double('Chef::RunList::RunListItem', name: 'one') }
  let(:run_list_item_two) { double('Chef::RunList::RunListItem', name: 'two') }
  let(:loaded_recipes) { %w(one) }
  let(:chef_run) { double('chef run', run_context: { loaded_recipes: loaded_recipes, node: node }) }

  subject { described_class.new }

  describe '#failure_message' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.failure_message).to eq('expected to include any recipe')
    end
  end

  describe '#failure_message_when_negated' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.failure_message_when_negated).to eq('expected not to include any recipes')
    end
  end

  describe '#description' do
    it 'has the right value' do
      subject.matches?(chef_run)
      expect(subject.description).to eq('include any recipe')
    end
  end

  describe '#matches?' do
    context 'when 0 recipes are included' do
      let(:loaded_recipes) { %w(one) }

      it 'returns false' do
        expect(subject.matches?(chef_run)).to be false
      end
    end

    context 'when at least one recipe is included' do
      let(:loaded_recipes) { %w(one two) }

      it 'returns true' do
        expect(subject.matches?(chef_run)).to be true
      end
    end
  end
end
