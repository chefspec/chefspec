require "spec_helper"

describe ChefSpec::Renderer do
  describe ".initialize" do
    it "accepts two arguments and assigns their instance variables" do
      instance = described_class.new("runner", "resource")
      expect(instance.chef_run).to eq("runner")
      expect(instance.resource).to eq("resource")
    end
  end

  let(:chef_run) { double("chef_run", { node: "node" }) }
  let(:variables) { {} }
  let(:resource) { double("resource", { cookbook: "cookbook", source: "source", variables: variables }) }
  subject { described_class.new(chef_run, resource) }

  describe "#content" do
    before do
      allow(subject).to receive(:content_from_cookbook_file).and_return("cookbook_file content")
      allow(subject).to receive(:content_from_file).and_return("file content")
      allow(subject).to receive(:content_from_template).and_return("template content")
    end

    context "when the resource is a cookbook_file" do
      it "renders the cookbook_file content" do
        allow(resource).to receive(:resource_name).and_return("cookbook_file")
        expect(subject.content).to eq("cookbook_file content")
      end
    end

    context "when the resource is a file" do
      it "renders the file content" do
        allow(resource).to receive(:resource_name).and_return("file")
        expect(subject.content).to eq("file content")
      end
    end

    context "when the resource is a template" do
      it "renders the template content" do
        allow(resource).to receive(:resource_name).and_return("template")
        expect(subject.content).to eq("template content")
      end
    end

    context "when the resource is not a file type" do
      it "returns nil" do
        allow(resource).to receive(:resource_name).and_return("service")
        expect(subject.content).to be_nil
      end
    end
  end

  describe "content_from_template" do
    before do
      cookbook_collection = {}
      cookbook_collection["cookbook"] = double("", { preferred_filename_on_disk_location: "/template/location" } )
      allow(subject).to receive(:cookbook_collection).with("node").and_return(cookbook_collection)
      allow(subject).to receive(:template_finder)

      allow(resource).to receive(:helper_modules).and_return([Module.new])
      allow(resource).to receive(:resource_name).and_return("template")
    end

    it "renders the template by extending modules for rendering paritals within the template" do
      chef_template_context = double("context", { render_template: 'rendered template content', update: nil })
      allow(Chef::Mixin::Template::TemplateContext).to receive(:new).and_return(chef_template_context)

      expect(chef_template_context).to receive(:_extend_modules).with(resource.helper_modules)

      expect(subject.content).to eq("rendered template content")
    end

    context 'with lazy variables' do
      let(:variables) { { 'a' => 1, 'b' => Chef::DelayedEvaluator.new { 2 } } }

      let(:template_context) do
        Class.new do
          def render_template(template)
            @attributes.to_json
          end

          def update(attributes)
            @attributes = attributes
          end

          def _extend_modules(module_names)
          end
        end
      end

      let(:chef_template_context) { template_context.new }

      before do
        allow(Chef::Mixin::Template::TemplateContext).to receive(:new).and_return(chef_template_context)
      end

      it 'renders the template by evaulating the lazy variables' do
        data = JSON.load(subject.content)

        expect(data['a']).to eq(1)
        expect(data['b']).to eq(2)
      end
    end
  end
end
