require 'chefspec'

describe 'ifconfig::delete' do
  platform 'ubuntu'

  describe 'deletes a ifconfig with an explicit action' do
    it { is_expected.to delete_ifconfig('10.0.0.2') }
    it { is_expected.to_not delete_ifconfig('10.0.0.10') }
  end

  describe 'deletes a ifconfig with attributes' do
    it { is_expected.to delete_ifconfig('10.0.0.3').with(device: 'en0') }
    it { is_expected.to_not delete_ifconfig('10.0.0.3').with(device: 'en1') }
  end
end
