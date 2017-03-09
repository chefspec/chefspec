require 'chefspec'

describe 'server::data_bag' do
  let(:chef_run) do
    ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04') do |_node, server|
      server.create_data_bag('accounts', 'github' => {
                                             'username' => 'sethvargo',
                                             'password' => 'p@ssW0rd!',
                                          },
                                          'twitter' => {
                                            'username' => 'sethvargo',
                                            'password' => '0th3r',
                                          })
    end.converge(described_recipe)
  end

  it 'does not raise an exception' do
    expect { chef_run }.to_not raise_error
  end

  it 'searches the Chef Server for the data bag' do
    expect(chef_run).to write_log('accounts')
      .with_message('data_bag_item[github], data_bag_item[twitter]')
  end
end
