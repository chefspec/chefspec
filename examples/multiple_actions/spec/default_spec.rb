require 'chefspec'

describe 'multiple_actions::default' do
  platform 'ubuntu'

  describe 'executes both actions' do
    it { is_expected.to enable_service('resource') }
    it { is_expected.to start_service('resource') }
  end

  describe 'does not match other actions' do
    it { is_expected.to_not disable_service('resource') }
  end
end
