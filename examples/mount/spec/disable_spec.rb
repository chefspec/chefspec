require 'chefspec'

describe 'mount::disable' do
  platform 'ubuntu'

  describe 'disables a mount with an explicit action' do
    it { is_expected.to disable_mount('/tmp/explicit_action') }
    it { is_expected.to_not disable_mount('/tmp/not_explicit_action') }
  end

  describe 'disables a mount with attributes' do
    it { is_expected.to disable_mount('/tmp/with_attributes').with(dump: 3) }
    it { is_expected.to_not disable_mount('/tmp/with_attributes').with(dump: 5) }
  end
end
