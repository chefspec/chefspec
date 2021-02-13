require 'chefspec'

describe 'script::run_ruby' do
  platform 'ubuntu'

  describe 'runs a ruby script with the default action' do
    it { is_expected.to run_ruby('default_action') }
    it { is_expected.to_not run_ruby('not_default_action') }
  end

  describe 'runs a ruby script with an explicit action' do
    it { is_expected.to run_ruby('explicit_action') }
  end

  describe 'runs a ruby script with attributes' do
    it { is_expected.to run_ruby('with_attributes').with(creates: 'creates') }
    it { is_expected.to_not run_ruby('with_attributes').with(creates: 'bacon') }
  end
end
