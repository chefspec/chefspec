require 'chefspec'

describe 'cron::delete' do
  platform 'ubuntu'

  describe 'deletes a cron with an explicit action' do
    it { is_expected.to delete_cron('explicit_action') }
    it { is_expected.to_not delete_cron('not_explicit_action') }
  end

  describe 'deletes a cron with attributes' do
    it { is_expected.to delete_cron('with_attributes').with(minute: '0', hour: '20') }
    it { is_expected.to_not delete_cron('with_attributes').with(minute: '10', hour: '30') }
  end
end
