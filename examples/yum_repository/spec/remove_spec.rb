require 'chefspec'

describe 'yum_repository::remove' do
  platform 'centos'

  describe 'removes a yum_repository with remove action' do
    it { is_expected.to remove_yum_repository('explicit_remove_action') }
  end
end
