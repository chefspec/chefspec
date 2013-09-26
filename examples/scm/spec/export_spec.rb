require 'chefspec'

describe 'scm::export' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'exports a scm with an explicit action' do
    expect(chef_run).to export_scm('/tmp/explicit_action')
  end

  it 'exports a scm with attributes' do
    expect(chef_run).to export_scm('/tmp/with_attributes').with(repository: 'ssh://scm.path')
  end

  it 'exports a scm when specifying the identity attribute' do
    expect(chef_run).to export_scm('/tmp/identity_attribute')
  end
end
