require 'chefspec'

describe 'ohai::reload' do
  platform 'ubuntu'

  describe 'reloads a ohai with the default action' do
    it { is_expected.to reload_ohai('default_action') }
    it { is_expected.to_not reload_ohai('not_default_action') }
  end

  describe 'reloads a ohai with an explicit action' do
    it { is_expected.to reload_ohai('explicit_action') }
  end

  describe 'reloads a ohai with attributes' do
    it { is_expected.to reload_ohai('with_attributes').with(plugin: 'plugin') }
    it { is_expected.to_not reload_ohai('with_attributes').with(plugin: 'not_plugin') }
  end

  describe 'reloads a ohai when specifying the identity attribute' do
    it { is_expected.to reload_ohai('identity_attribute') }
  end
end
