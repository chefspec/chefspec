require 'spec_helper'

describe ChefSpec::Renderer do
  describe '.initialize' do
    it 'accepts two arguments and assigns their instance variables' do
      instance = described_class.new('runner', 'resource')
      expect(instance.chef_run).to eq('runner')
      expect(instance.resource).to eq('resource')
    end
  end

  let(:chef_run) { double('chef_run') }
  let(:resource) { double('resource') }
  subject { described_class.new(chef_run, resource) }

  describe '#content' do
    before do
      subject.stub(:content_from_cookbook_file).and_return('cookbook_file content')
      subject.stub(:content_from_file).and_return('file content')
      subject.stub(:content_from_template).and_return('template content')
    end

    context 'when the resource is a cookbook_file' do
      it 'renders the cookbook_file content' do
        resource.stub(:resource_name).and_return('cookbook_file')
        expect(subject.content).to eq('cookbook_file content')
      end
    end

    context 'when the resource is a file' do
      it 'renders the file content' do
        resource.stub(:resource_name).and_return('file')
        expect(subject.content).to eq('file content')
      end
    end

    context 'when the resource is a template' do
      it 'renders the template content' do
        resource.stub(:resource_name).and_return('template')
        expect(subject.content).to eq('template content')
      end
    end

    context 'when the resource is not a file type' do
      it 'returns nil' do
        resource.stub(:resource_name).and_return('service')
        expect(subject.content).to be_nil
      end
    end
  end
end
