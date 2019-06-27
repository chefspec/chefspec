require 'chefspec'

describe 'dsc_script::run' do
  let(:chef_run) do
    ChefSpec::SoloRunner.new(platform: 'windows', version: '2016')
                        .converge(described_recipe)
  end

  it 'runs dsc_script with default action' do
    expect(chef_run).to run_dsc_script('default_action')
  end

  it 'runs dsc_script with explicit action' do
    expect(chef_run).to run_dsc_script('explicit_action')
  end
end
