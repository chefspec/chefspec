require 'chefspec'

describe 'subversion::export' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'exports a subversion with an explicit action' do
    expect(chef_run).to export_subversion('/tmp/explicit_action')
  end

  it 'exports a subversion with attributes' do
    expect(chef_run).to export_subversion('/tmp/with_attributes').with(repository: 'ssh://subversion.path')
  end

  it 'exports a subversion when specifying the identity attribute' do
    expect(chef_run).to export_subversion('/tmp/identity_attribute')
  end
end
