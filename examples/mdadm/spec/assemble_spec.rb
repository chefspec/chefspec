require 'chefspec'

describe 'mdadm::assemble' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'assembles a mdadm with an explicit action' do
    expect(chef_run).to assemble_mdadm('explicit_action')
    expect(chef_run).to_not assemble_mdadm('not_explicit_action')
  end

  it 'assembles a mdadm with attributes' do
    expect(chef_run).to assemble_mdadm('with_attributes').with(chunk: 8)
    expect(chef_run).to_not assemble_mdadm('with_attributes').with(chunk: 3)
  end

  it 'assembles a mdadm when specifying the identity attribute' do
    expect(chef_run).to assemble_mdadm('identity_attribute')
  end
end
