require 'chefspec'

describe 'reboot::now' do
  platform 'ubuntu'

  describe 'runs a reboot_now when specifying action' do
    it { is_expected.to now_reboot('explicit_action') }
  end
end
