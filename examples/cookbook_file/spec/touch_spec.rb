require 'chefspec'

describe 'cookbook_file::touch' do
  platform 'ubuntu'

  describe 'touches a cookbook_file with an explicit action' do
    it { is_expected.to touch_cookbook_file('/tmp/explicit_action') }
    it { is_expected.to_not touch_cookbook_file('/tmp/not_explicit_action') }
  end

  describe 'touches a cookbook_file with attributes' do
    it { is_expected.to touch_cookbook_file('/tmp/with_attributes').with(backup: false) }
    it { is_expected.to_not touch_cookbook_file('/tmp/with_attributes').with(backup: true) }
  end

  describe 'touches a cookbook_file when specifying the identity attribute' do
    it { is_expected.to touch_cookbook_file('/tmp/identity_attribute') }
  end
end
