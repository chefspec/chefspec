require 'chefspec'

describe 'cron::create' do
  platform 'ubuntu'

  describe 'creates a cron with the default action' do
    it { is_expected.to create_cron('default_action') }
    it { is_expected.to_not create_cron('not_default_action') }
  end

  describe 'creates a cron with an explicit action' do
    it { is_expected.to create_cron('explicit_action') }
  end

  describe 'creates a cron with attributes' do
    it { is_expected.to create_cron('with_attributes').with(minute: '0', hour: '20') }
    it { is_expected.to_not create_cron('with_attributes').with(minute: '10', hour: '30') }
  end
end
