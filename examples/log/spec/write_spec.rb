require 'chefspec'

describe 'log::write' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'writes a log with the default action' do
    expect(chef_run).to write_log('default_action')
    expect(chef_run).to_not write_log('not_default_action')
  end

  # CHEF-4561
  # it 'writes a log with an explicit action' do
  #   expect(chef_run).to write_log('explicit_action')
  # end

  it 'writes a log with attributes' do
    expect(chef_run).to write_log('with_attributes').with(level: :debug)
    expect(chef_run).to_not write_log('with_attributes').with(level: :info)
  end

  it 'writes a log when specifying the identity attribute' do
    expect(chef_run).to write_log('identity_attribute')
  end
end
