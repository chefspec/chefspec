require 'chefspec'

describe 'systemd_unit::stop' do
  platform 'ubuntu'

  describe 'stops a systemd_unit daemon with an explicit action' do
    it { is_expected.to stop_systemd_unit('explicit_action') }
    it { is_expected.to_not stop_systemd_unit('not_explicit_action') }
  end
end
