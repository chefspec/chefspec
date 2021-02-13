require 'chefspec'

describe 'systemd_unit::delete' do
  platform 'ubuntu'

  describe 'deletes a systemd_unit with an explicit action' do
    it { is_expected.to delete_systemd_unit('explicit_action') }
    it { is_expected.to_not delete_systemd_unit('not_explicit_action') }
  end
end
