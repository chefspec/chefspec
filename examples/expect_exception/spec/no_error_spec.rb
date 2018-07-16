require 'chefspec'

describe 'expect_exception::no_error' do
  let(:chef_run) { ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '18.04').converge(described_recipe) }

  it 'does not raise an error' do
    expect(Chef::Formatters::ErrorMapper).to_not receive(:file_load_failed)
    expect { chef_run }.to_not raise_error
  end
end
