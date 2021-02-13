require 'chefspec'

describe 'env::create' do
  platform 'windows'

  describe 'creates a env with the default action' do
    it { is_expected.to create_env('default_action') }
    it { is_expected.to_not create_env('not_default_action') }
  end

  describe 'creates a env with an explicit action' do
    it { is_expected.to create_env('explicit_action') }
  end

  describe 'creates a env with attributes' do
    it { is_expected.to create_env('with_attributes').with(value: 'value') }
    it { is_expected.to_not create_env('with_attributes').with(value: 'not_value') }
  end

  describe 'creates a env when specifying the identity attribute' do
    it { is_expected.to create_env('identity_attribute') }
  end
end
