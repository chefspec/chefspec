require 'chefspec'

describe 'custom_matcher::install' do
  platform 'ubuntu'

  describe 'installs a custom_matcher with the default action' do
    it { is_expected.to install_custom_matcher_thing('default_action') }
    it { is_expected.to_not install_custom_matcher_thing('not_default_action') }
  end

  describe 'installs a custom_matcher with an explicit action' do
    it { is_expected.to install_custom_matcher_thing('explicit_action') }
  end

  describe 'installs a custom_matcher with attributes' do
    it { is_expected.to install_custom_matcher_thing('with_attributes').with(config: true) }
    it { is_expected.to_not install_custom_matcher_thing('with_attributes').with(config: false) }
  end

  describe 'installs a custom_matcher when specifying the identity attribute' do
    it { is_expected.to install_custom_matcher_thing('identity_attribute') }
  end

  describe 'defines a runner method' do
    it { is_expected.to respond_to(:custom_matcher_thing) }
  end
end
