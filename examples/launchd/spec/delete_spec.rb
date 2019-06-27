require 'chefspec'

describe 'launchd::delete' do
  platform 'mac_os_x'

  describe 'deletes a launchd with an explicit action' do
    it { is_expected.to delete_launchd('explicit_action') }
    it { is_expected.to_not delete_launchd('not_explicit_action') }
  end
end
