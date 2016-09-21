require 'chefspec'

describe 'link::delete' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'deletes a link with an explicit action' do
    expect(chef_run).to delete_link('/tmp/explicit_action')
    expect(chef_run).to_not delete_link('/tmp/not_explicit_action')
  end

  it 'deletes a link with attributes' do
    expect(chef_run).to delete_link('/tmp/with_attributes').with(to: 'destination')
    expect(chef_run).to_not delete_link('/tmp/with_attributes').with(to: 'other_destination')
  end

  it 'deletes a link when specifying the identity attribute' do
    expect(chef_run).to delete_link('/tmp/identity_attribute')
  end
end
