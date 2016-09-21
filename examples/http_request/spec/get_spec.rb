require 'chefspec'

describe 'http_request::get' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'gets a http_request with the default action' do
    expect(chef_run).to get_http_request('default_action')
    expect(chef_run).to_not get_http_request('not_default_action')
  end

  it 'gets a http_request with an explicit action' do
    expect(chef_run).to get_http_request('explicit_action')
  end

  it 'gets a http_request with attributes' do
    expect(chef_run).to get_http_request('with_attributes').with(url: 'http://my.url')
    expect(chef_run).to_not get_http_request('with_attributes').with(url: 'http://my.other.url')
  end

  it 'gets a http_request when specifying the identity attribute' do
    expect(chef_run).to get_http_request('identity_attribute')
  end
end
