require 'chefspec'

describe 'service::reload' do
  platform 'ubuntu'

  describe 'reloads a service with an explicit action' do
    it { is_expected.to reload_service('explicit_action') }
    it { is_expected.to_not reload_service('not_explicit_action') }
  end

  describe 'reloads a service with attributes' do
    it { is_expected.to reload_service('with_attributes').with(pattern: 'pattern') }
    it { is_expected.to_not reload_service('with_attributes').with(pattern: 'bacon') }
  end

  describe 'reloads a service when specifying the identity attribute' do
    it { is_expected.to reload_service('identity_attribute') }
  end
end
