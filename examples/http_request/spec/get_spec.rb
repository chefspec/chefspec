require 'chefspec'

describe 'http_request::get' do
  platform 'ubuntu'

  describe 'gets a http_request with the default action' do
    it { is_expected.to get_http_request('default_action') }
    it { is_expected.to_not get_http_request('not_default_action') }
  end

  describe 'gets a http_request with an explicit action' do
    it { is_expected.to get_http_request('explicit_action') }
  end

  describe 'gets a http_request with attributes' do
    it { is_expected.to get_http_request('with_attributes').with(url: 'http://my.url') }
    it { is_expected.to_not get_http_request('with_attributes').with(url: 'http://my.other.url') }
  end

  describe 'gets a http_request when specifying the identity attribute' do
    it { is_expected.to get_http_request('identity_attribute') }
  end
end
