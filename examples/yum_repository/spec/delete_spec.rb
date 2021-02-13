require 'chefspec'

describe 'yum_repository::delete' do
  platform 'centos'

  describe 'removes a yum_repository with delete action' do
    it { is_expected.to delete_yum_repository('explicit_delete_action') }
  end
end
