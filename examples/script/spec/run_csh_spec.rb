require 'chefspec'

describe 'script::run_csh' do
  platform 'ubuntu'

  describe 'runs a csh script with the default action' do
    it { is_expected.to run_csh('default_action') }
    it { is_expected.to_not run_csh('not_default_action') }
  end

  describe 'runs a csh script with an explicit action' do
    it { is_expected.to run_csh('explicit_action') }
  end

  describe 'runs a csh script with attributes' do
    it { is_expected.to run_csh('with_attributes').with(creates: 'creates') }
    it { is_expected.to_not run_csh('with_attributes').with(creates: 'bacon') }
  end
end
