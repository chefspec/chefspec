require 'chefspec'

RSpec.configure do |config|
  config.platform = 'windows'
  config.version  = '2012R2'
end

describe 'dsc_resource::run' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  it 'runs dsc_resource with the archive resource' do
    expect(chef_run).to run_dsc_resource('archive resource').with(
      resource: :archive,
      properties: {
        ensure: 'present',
        path: 'C:\Users\Public\Documents\example.zip'
        destination: 'C:\Users\Public\Documents\ExtractionPath'
      })
  end

  it 'runs dsc_resource with the group resource' do
    expect(chef_run).to run_dsc_resource('group resource').with(
      resource: :group,
      properties: {
        groupname: 'demo1',
        ensure: 'present'
      })
  end

  it 'runs dsc_resource with the user resource' do
    expect(chef_run).to run_dsc_resource('user resource').with(
      resource: :user,
      properties: {
        username: 'Foobar1',
        fullname: 'Foobar1',
        password: ps_credential('P@assword!'),
        ensure: 'present'
      })
  end
end
