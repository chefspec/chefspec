require 'chefspec'

describe 'render_file::template_helpers' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'renders the file using a helper' do
    expect(chef_run).to render_file('/tmp/template_with_helper')
      .with_content(/^helper result: hello$/)
  end
end
