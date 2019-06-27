require 'chefspec'

describe 'render_file::template_helpers' do
  platform 'ubuntu'

  describe 'renders the file using a helper' do
    it {
      is_expected.to render_file('/tmp/template_with_helper')
        .with_content(/^helper result: hello$/)
    }
  end
end
