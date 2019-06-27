require 'chefspec'

describe 'yum_repository::makecache' do
  platform 'centos'

  describe 'makes cache for a yum_repository' do
    it { is_expected.to makecache_yum_repository('explicit_makecache_action') }
  end
end
