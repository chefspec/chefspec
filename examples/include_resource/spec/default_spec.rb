require 'chefspec'

describe 'include_resource::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'includes the my_resource resource' do
    expect(chef_run).to include_resource('file')
  end

  it 'does not include the my_other_resource resource' do
    expect(chef_run).to_not include_resource('directory')
  end
end
