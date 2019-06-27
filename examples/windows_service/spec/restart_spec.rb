require 'chefspec'

describe 'windows_service::restart' do
  platform 'windows'

  describe 'restarts a windows_service with an explicit action' do
    it { is_expected.to restart_windows_service('explicit_action') }
    it { is_expected.to_not restart_windows_service('not_explicit_action') }
  end

  describe 'restarts a windows_service with attributes' do
    it { is_expected.to restart_windows_service('with_attributes').with(pattern: 'pattern') }
    it { is_expected.to_not restart_windows_service('with_attributes').with(pattern: 'bacon') }
  end

  describe 'restarts a windows_service when specifying the identity attribute' do
    it { is_expected.to restart_windows_service('identity_attribute') }
  end
end
