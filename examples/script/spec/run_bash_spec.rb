require 'chefspec'

describe 'script::run_bash' do
  platform 'ubuntu'

  describe 'runs a bash script with the default action' do
    it { is_expected.to run_bash('default_action') }
    it { is_expected.to_not run_bash('not_default_action') }
  end

  describe 'runs a bash script with an explicit action' do
    it { is_expected.to run_bash('explicit_action') }
  end

  describe 'runs a bash script with attributes' do
    it { is_expected.to run_bash('with_attributes').with(creates: 'creates') }
    it { is_expected.to_not run_bash('with_attributes').with(creates: 'bacon') }
  end
end
