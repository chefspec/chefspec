require 'chefspec'

describe 'mount::enable' do
  platform 'ubuntu'

  describe 'enables a mount with an explicit action' do
    it { is_expected.to enable_mount('/tmp/explicit_action') }
    it { is_expected.to_not enable_mount('/tmp/not_explicit_action') }
  end

  describe 'enables a mount with attributes' do
    it { is_expected.to enable_mount('/tmp/with_attributes').with(dump: 3) }
    it { is_expected.to_not enable_mount('/tmp/with_attributes').with(dump: 5) }
  end
end
