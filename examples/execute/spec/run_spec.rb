require 'chefspec'

describe 'execute::run' do
  platform 'ubuntu'

  describe 'runs a execute with the default action' do
    it { is_expected.to run_execute('default_action') }
    it { is_expected.to_not run_execute('not_default_action') }
  end

  describe 'runs a execute with an explicit action' do
    it { is_expected.to run_execute('explicit_action') }
  end

  describe 'runs a execute with attributes' do
    it { is_expected.to run_execute('with_attributes').with(user: 'user') }
    it { is_expected.to_not run_execute('with_attributes').with(user: 'not_user') }
  end

  describe 'runs a execute when specifying the identity attribute' do
    it { is_expected.to run_execute('identity_attribute') }
  end
end
