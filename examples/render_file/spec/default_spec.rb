require 'chefspec'

describe 'render_file::default' do
  let(:chef_run) { ChefSpec::ServerRunner.new(platform: 'ubuntu', version: '16.04').converge(described_recipe) }

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

    it 'renders the file when given a block' do
      expect(chef_run).to render_file('/tmp/file').with_content { |content|
        expect(content).to include('This is content!')
      }

      expect(chef_run).to render_file('/tmp/file').with_content { |content|
        expect(content).to_not include('This is not content!')
      }
    end

    it 'renders the file with content matching arbitrary matcher' do
      expect(chef_run).to render_file('/tmp/file').with_content(
        start_with('This')
      )
      expect(chef_run).to_not render_file('/tmp/file').with_content(
        end_with('not')
      )
    end
  end

  context 'cookbook_file' do
    shared_examples 'renders file' do
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

      it 'renders the file when given a block' do
        expect(chef_run).to render_file('/tmp/cookbook_file').with_content { |content|
          expect(content).to include('This is content!')
        }

        expect(chef_run).to render_file('/tmp/cookbook_file').with_content { |content|
          expect(content).to_not include('This is not content!')
        }
      end

      it 'renders the file with content matching arbitrary matcher' do
        expect(chef_run).to render_file('/tmp/cookbook_file').with_content(
          start_with('This')
        )
        expect(chef_run).to_not render_file('/tmp/cookbook_file').with_content(
          end_with('not')
        )
      end
    end

    context 'with a pristine filesystem' do
      it_behaves_like 'renders file'
    end

    context 'with a same rendered file on filesystem' do
      before do
        allow(File).to receive(:read).and_call_original
        allow(File).to receive(:read).with('/tmp/cookbook_file', 'rb').and_yield('This is content!')
      end

      it_behaves_like 'renders file'
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

    it 'renders the file when given a block' do
      expect(chef_run).to render_file('/tmp/template').with_content { |content|
        expect(content).to include('This is content!')
      }

      expect(chef_run).to render_file('/tmp/template').with_content { |content|
        expect(content).to_not include('This is not content!')
      }
    end

    it 'renders the file with content matching arbitrary matcher' do
      expect(chef_run).to render_file('/tmp/template').with_content(
        start_with('This')
      )
      expect(chef_run).to_not render_file('/tmp/template').with_content(
        end_with('not')
      )
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

    it 'renders the file when given a block' do
      expect(chef_run).to render_file('/tmp/partial').with_content { |content|
        expect(content).to include('has a partial')
      }

      expect(chef_run).to render_file('/tmp/partial').with_content { |content|
        expect(content).to_not include('not a template partial')
      }
    end

    it 'renders the file with matching content' do
      expect(chef_run).to render_file('/tmp/partial').with_content(/^This(.+)$/)
      expect(chef_run).to_not render_file('/tmp/partial').with_content(/^Not(.+)$/)
    end
  end
end
