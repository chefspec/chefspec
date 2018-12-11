# When the default_source is a chef_server, we will use the ChefZero Server to test

RSpec.configure do |config|
  tmpdir = Dir.mktmpdir

  config.before(:suite) do
    # Setup the private key to authenticate against ChefZero Server
    # inspired by ServerRunner#apply_chef_config!
    path = File.join(tmpdir, 'client.pem')
    File.open(path, 'wb') { |f| f.write(ChefZero::PRIVATE_KEY) }

    Chef::Config[:client_key]  = path
    Chef::Config[:client_name] = 'chefspec'
    Chef::Config[:node_name]   = 'chefspec'
  end

  config.after(:suite) do
    # cleanup private key
    FileUtils.rm_rf(tmpdir)
  end
end
