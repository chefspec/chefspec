require 'chefspec'

describe 'launchd::create' do
  platform 'mac_os_x'

  describe 'creates a launchd daemon with an explicit action' do
    it { is_expected.to create_launchd('explicit_action') }
    it { is_expected.to_not create_launchd('not_explicit_action') }
  end

  describe 'creates a launchd daemon with a default_action action' do
    it { is_expected.to create_launchd('default_action') }
  end
end
