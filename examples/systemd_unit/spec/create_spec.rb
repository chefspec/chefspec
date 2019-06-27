require 'chefspec'

describe 'systemd_unit::create' do
  platform 'ubuntu'

  describe 'creates a systemd unit with an explicit action' do
    it { is_expected.to create_systemd_unit('explicit_action') }
    it { is_expected.to_not create_systemd_unit('not_explicit_action') }
  end
end
