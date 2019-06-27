require 'chefspec'

describe 'yum_repository::add' do
  platform 'centos'

  describe 'creates a yum_repository with add action' do
    it { is_expected.to add_yum_repository('explicit_add_action') }
  end
end
