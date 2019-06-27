require 'chefspec'

describe 'template::touch' do
  platform 'ubuntu'

  describe 'touches a template with an explicit action' do
    it { is_expected.to touch_template('/tmp/explicit_action') }
    it { is_expected.to_not touch_template('/tmp/not_explicit_action') }
  end

  describe 'touches a template with attributes' do
    it { is_expected.to touch_template('/tmp/with_attributes').with(backup: false) }
    it { is_expected.to_not touch_template('/tmp/with_attributes').with(backup: true) }
  end

  describe 'touches a template when specifying the identity attribute' do
    it { is_expected.to touch_template('/tmp/identity_attribute') }
  end
end
