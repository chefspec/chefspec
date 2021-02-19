require "chefspec"

describe "render_file::default" do
  platform "ubuntu"

  context "file" do
    describe "renders the file" do
      it { is_expected.to render_file("/tmp/file") }
      it { is_expected.to_not render_file("/tmp/not_file") }
    end

    describe "renders the file with content" do
      it { is_expected.to render_file("/tmp/file").with_content("This is content!") }
      it { is_expected.to_not render_file("/tmp/file").with_content("This is not content!") }
    end

    describe "renders the file with matching content" do
      it { is_expected.to render_file("/tmp/file").with_content(/^This(.+)$/) }
      it { is_expected.to_not render_file("/tmp/file").with_content(/^Not(.+)$/) }
    end

    describe "renders the file when given a block" do
      it {
        is_expected.to(render_file("/tmp/file").with_content { |content|
          expect(content).to include("This is content!")
        })
      }

      it {
        is_expected.to( render_file("/tmp/file").with_content { |content|
          expect(content).to_not include("This is not content!")
        })
      }
    end

    describe "renders the file with content matching arbitrary matcher" do
      it {
        is_expected.to render_file("/tmp/file").with_content(
          start_with("This")
        )
      }
      it {
        is_expected.to_not render_file("/tmp/file").with_content(
          end_with("not")
        )
      }
    end
  end

  context "cookbook_file" do
    shared_examples "renders file" do
      describe "renders the file" do
        it { is_expected.to render_file("/tmp/cookbook_file") }
        it { is_expected.to_not render_file("/tmp/not_cookbook_file") }
      end

      describe "renders the file with content" do
        it { is_expected.to render_file("/tmp/cookbook_file").with_content("This is content!") }
        it { is_expected.to_not render_file("/tmp/cookbook_file").with_content("This is not content!") }
      end

      describe "renders the file with matching content" do
        it { is_expected.to render_file("/tmp/cookbook_file").with_content(/^This(.+)$/) }
        it { is_expected.to_not render_file("/tmp/cookbook_file").with_content(/^Not(.+)$/) }
      end

      describe "renders the file when given a block" do
        it {
          is_expected.to(render_file("/tmp/cookbook_file").with_content { |content|
            expect(content).to include("This is content!")
          })
        }

        it {
          is_expected.to(render_file("/tmp/cookbook_file").with_content { |content|
            expect(content).to_not include("This is not content!")
          })
        }
      end

      describe "renders the file with content matching arbitrary matcher" do
        it {
          is_expected.to render_file("/tmp/cookbook_file").with_content(
            start_with("This")
          )
        }
        it {
          is_expected.to_not render_file("/tmp/cookbook_file").with_content(
            end_with("not")
          )
        }
      end

      describe "renders the file with chained content matchers" do
        it {
          is_expected.to render_file("/tmp/cookbook_file")
            .with_content("This")
            .with_content("is")
            .with_content("content!")
        }
        it {
          is_expected.to_not render_file("/tmp/cookbook_file")
            .with_content("Sparta!")
            .with_content("is")
            .with_content("This")
        }
      end
    end

    context "with a pristine filesystem" do
      it_behaves_like "renders file"
    end

    context "with a same rendered file on filesystem" do
      before do
        allow(File).to receive(:read).and_call_original
        allow(File).to receive(:read).with("/tmp/cookbook_file", "rb").and_yield("This is content!")
      end

      it_behaves_like "renders file"
    end
  end

  context "template" do
    describe "renders the file" do
      it { is_expected.to render_file("/tmp/template") }
      it { is_expected.to_not render_file("/tmp/not_template") }
    end

    describe "renders the file with content" do
      it { is_expected.to render_file("/tmp/template").with_content("This is content!") }
      it { is_expected.to_not render_file("/tmp/template").with_content("This is not content!") }
    end

    describe "renders the file with matching content" do
      it { is_expected.to render_file("/tmp/template").with_content(/^This(.+)$/) }
      it { is_expected.to_not render_file("/tmp/template").with_content(/^Not(.+)$/) }
    end

    describe "renders the file when given a block" do
      it {
        is_expected.to(render_file("/tmp/template").with_content { |content|
          expect(content).to include("This is content!")
        })
      }

      it {
        is_expected.to(render_file("/tmp/template").with_content { |content|
          expect(content).to_not include("This is not content!")
        })
      }
    end

    describe "renders the file with content matching arbitrary matcher" do
      it {
        is_expected.to render_file("/tmp/template").with_content(
          start_with("This")
        )
      }
      it {
        is_expected.to_not render_file("/tmp/template").with_content(
          end_with("not")
        )
      }
    end
  end

  context "template with render" do
    describe "renders the file" do
      it { is_expected.to render_file("/tmp/partial") }
      it { is_expected.to_not render_file("/tmp/not_partial") }
    end

    describe "renders the file with content" do
      it { is_expected.to render_file("/tmp/partial").with_content("This template has a partial: This is a template partial!") }
      it { is_expected.to_not render_file("/tmp/partial").with_content("This template has a partial: This is not a template partial!") }
    end

    describe "renders the file when given a block" do
      it {
        is_expected.to(render_file("/tmp/partial").with_content { |content|
          expect(content).to include("has a partial")
        })
      }

      it {
        is_expected.to(render_file("/tmp/partial").with_content { |content|
          expect(content).to_not include("not a template partial")
        })
      }
    end

    describe "renders the file with matching content" do
      it { is_expected.to render_file("/tmp/partial").with_content(/^This(.+)$/) }
      it { is_expected.to_not render_file("/tmp/partial").with_content(/^Not(.+)$/) }
    end
  end
end
