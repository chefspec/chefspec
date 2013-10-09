require 'chefspec'

describe 'render_file::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'file' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/file')
      expect(chef_run).to_not render_file('/tmp/not_file')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/file').with_content('This is content!')
      expect(chef_run).to_not render_file('/tmp/file').with_content('This is not content!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/file').with_content(/^This(.+)$/)
      expect(chef_run).to_not render_file('/tmp/file').with_content(/^Not(.+)$/)
    end
  end

  context 'cookbook_file' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/cookbook_file')
      expect(chef_run).to_not render_file('/tmp/not_cookbook_file')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/cookbook_file').with_content('This is content!')
      expect(chef_run).to_not render_file('/tmp/cookbook_file').with_content('This is not content!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/cookbook_file').with_content(/^This(.+)$/)
      expect(chef_run).to_not render_file('/tmp/cookbook_file').with_content(/^Not(.+)$/)
    end
  end

  context 'template' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/template')
      expect(chef_run).to_not render_file('/tmp/not_template')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/template').with_content('This is content!')
      expect(chef_run).to_not render_file('/tmp/template').with_content('This is not content!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/template').with_content(/^This(.+)$/)
      expect(chef_run).to_not render_file('/tmp/template').with_content(/^Not(.+)$/)
    end
  end

  context 'template with render' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/partial')
      expect(chef_run).to_not render_file('/tmp/not_partial')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/partial').with_content('This template has a partial: This is a template partial!')
      expect(chef_run).to_not render_file('/tmp/partial').with_content('This template has a partial: This is not a template partial!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/partial').with_content(/^This(.+)$/)
      expect(chef_run).to_not render_file('/tmp/partial').with_content(/^Not(.+)$/)
    end
  end
end
