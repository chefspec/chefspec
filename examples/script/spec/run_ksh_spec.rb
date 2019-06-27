require 'chefspec'

describe 'script::run_ksh' do
  platform 'ubuntu'

  describe 'runs a ksh script with the default action' do
    it { is_expected.to run_ksh('default_action') }
    it { is_expected.to_not run_ksh('not_default_action') }
  end

  describe 'runs a ksh script with an explicit action' do
    it { is_expected.to run_ksh('explicit_action') }
  end

  describe 'runs a ksh script with attributes' do
    it { is_expected.to run_ksh('with_attributes').with(creates: 'creates') }
    it { is_expected.to_not run_ksh('with_attributes').with(creates: 'bacon') }
  end
end
