require 'chefspec'

describe 'service::restart' do
  platform 'ubuntu'

  describe 'restarts a service with an explicit action' do
    it { is_expected.to restart_service('explicit_action') }
    it { is_expected.to_not restart_service('not_explicit_action') }
  end

  describe 'restarts a service with attributes' do
    it { is_expected.to restart_service('with_attributes').with(pattern: 'pattern') }
    it { is_expected.to_not restart_service('with_attributes').with(pattern: 'bacon') }
  end

  describe 'restarts a service when specifying the identity attribute' do
    it { is_expected.to restart_service('identity_attribute') }
  end
end
