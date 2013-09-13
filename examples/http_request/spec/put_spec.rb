require 'chefspec'

describe 'http_request::put' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'puts a http_request with an explicit action' do
    expect(chef_run).to put_http_request('explicit_action')
  end

  it 'puts a http_request with attributes' do
    expect(chef_run).to put_http_request('with_attributes').with(url: 'http://my.url')
  end

  it 'puts a http_request when specifying the identity attribute' do
    expect(chef_run).to put_http_request('identity_attribute')
  end
end
