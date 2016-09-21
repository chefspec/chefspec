require 'chefspec'

describe 'render_file::template_helpers' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

  it 'renders the file using a helper' do
    expect(chef_run).to render_file('/tmp/template_with_helper')
      .with_content(/^helper result: hello$/)
  end
end
