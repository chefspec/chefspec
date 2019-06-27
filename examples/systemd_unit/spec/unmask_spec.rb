require 'chefspec'

describe 'systemd_unit::unmask' do
  platform 'ubuntu'

  describe 'unmasks a systemd_unit daemon with an explicit action' do
    it { is_expected.to unmask_systemd_unit('explicit_action') }
    it { is_expected.to_not unmask_systemd_unit('not_explicit_action') }
  end
end
