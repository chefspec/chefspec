require 'chefspec'

describe 'apt_repository::remove' do
  platform 'ubuntu'

  describe 'removes a apt_repository with default action' do
    it { is_expected.to remove_apt_repository('explicit_remove_action') }
  end
end
