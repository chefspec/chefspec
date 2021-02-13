require 'chefspec'

describe 'launchd::enable' do
  platform 'mac_os_x'

  describe 'enables a launchd daemon with an explicit action' do
    it { is_expected.to enable_launchd('explicit_action') }
    it { is_expected.to_not enable_launchd('not_explicit_action') }
  end
end
