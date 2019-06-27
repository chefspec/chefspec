require 'chefspec'

describe 'route::delete' do
  platform 'ubuntu'

  describe 'deletes a route with an explicit action' do
    it { is_expected.to delete_route('10.0.0.2') }
    it { is_expected.to_not delete_route('10.0.0.10') }
  end

  describe 'deletes a route with attributes' do
    it { is_expected.to delete_route('10.0.0.3').with(gateway: '10.0.0.0') }
    it { is_expected.to_not delete_route('10.0.0.3').with(gateway: '10.0.0.100') }
  end

  describe 'deletes a route when specifying the identity attribute' do
    it { is_expected.to delete_route('10.0.0.4') }
  end
end
