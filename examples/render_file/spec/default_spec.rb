require 'chefspec'

describe 'render_file::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  context 'file' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/file')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/file').with_content('This is content!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/file').with_content(/^This(.+)$/)
    end
  end

  context 'cookbook_file' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/cookbook_file')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/cookbook_file').with_content('This is content!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/cookbook_file').with_content(/^This(.+)$/)
    end
  end

  context 'template' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/template')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/template').with_content('This is content!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/template').with_content(/^This(.+)$/)
    end
  end

  context 'template with render' do
    it 'renders the file' do
      expect(chef_run).to render_file('/tmp/partial')
    end

    it 'renders the file with content' do
      expect(chef_run).to render_file('/tmp/partial').with_content('This template has a partial: This is a template partial!')
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/partial').with_content(/^This(.+)$/)
    end
  end
end
