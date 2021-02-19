require 'chefspec'

describe 'yum_repository::create' do
  platform 'centos'

  describe 'create a yum_repository with default action' do
    it { is_expected.to create_yum_repository('default_action') }
    it { is_expected.to_not create_yum_repository('not_default_action') }
  end

  describe 'creates a yum_repository with create action' do
    it { is_expected.to create_yum_repository('explicit_action') }
  end
end
