require 'chefspec'

describe 'systemd_unit::mask' do
  platform 'ubuntu'

  describe 'masks a systemd unit with an explicit action' do
    it { is_expected.to mask_systemd_unit('explicit_action') }
    it { is_expected.to_not mask_systemd_unit('not_explicit_action') }
  end
end
