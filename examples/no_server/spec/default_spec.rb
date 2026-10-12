require 'chefspec'

describe 'no_server::default' do
  platform 'ubuntu'

  it { is_expected.to write_log('no_server') }

  it 'does not start a chef-zero server' do
    expect(ChefSpec::ZeroServer.server).to_not be_running
  end
end
