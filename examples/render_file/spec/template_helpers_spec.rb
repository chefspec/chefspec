require 'chefspec'

describe 'render_file::template_helpers' do
  platform 'ubuntu'

  describe 'renders the file using a helper' do
    it {
      is_expected.to render_file('/tmp/template_with_helper')
        .with_content(/^helper result: hello$/)
    }
  end

  describe 'renders the file using Chef\'s template helper variables' do
    it {
      is_expected.to render_file('/tmp/template_with_variables')
        .with_content(/^cookbook: render_file$/)
    }

    it {
      is_expected.to render_file('/tmp/template_with_variables')
        .with_content(/^template: template_with_variables\.erb$/)
    }

    it {
      is_expected.to render_file('/tmp/template_with_variables')
        .with_content(/^recipe: template_helpers$/)
    }
  end
end
