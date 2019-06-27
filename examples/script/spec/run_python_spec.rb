require 'chefspec'

describe 'script::run_python' do
  platform 'ubuntu'

  describe 'runs a python script with the default action' do
    it { is_expected.to run_python('default_action') }
    it { is_expected.to_not run_python('not_default_action') }
  end

  describe 'runs a python script with an explicit action' do
    it { is_expected.to run_python('explicit_action') }
  end

  describe 'runs a python script with attributes' do
    it { is_expected.to run_python('with_attributes').with(creates: 'creates') }
    it { is_expected.to_not run_python('with_attributes').with(creates: 'bacon') }
  end
end
