require 'spec_helper'

# Note: These specs don't use Berkshelf code directly as this project doesn't
# have a direct dependency on Berkshelf and loading it would impact the
# perfance of these specs. While not ideal, the test doubles provide enough of
# a standin for Berkshelf to exercise the `#matches?` behavior.
describe ChefSpec::Coverage::BerkshelfFilter do
  let(:dependencies) do
    [double('Berkshelf::Dependency', metadata?: true, name: "cookbookery")]
  end
  let(:berksfile) { double('Berkshelf::Berksfile', dependencies: dependencies) }
  let(:resource) { Chef::Resource.new('theone') }
  subject { described_class.new(berksfile) }

  describe '#matches?' do
    it 'returns truthy if resource source_line is nil' do
      expect(subject.matches?(resource)).to be_truthy
    end

    context 'when resource#source_line is under target cookbook' do
      it 'normal unix path returns truthy' do
        resource.source_line =
          '/path/to/cookbooks/nope/recipes/default.rb:22'
        expect(subject.matches?(resource)).to be_truthy
      end

      it 'normal windows path returns truthy' do
        resource.source_line =
          'C:\\path\\to\\cookbooks\\nope\\recipes\\default.rb:22'
        expect(subject.matches?(resource)).to be_truthy
      end

      it 'mixed windows path returns truthy' do
        resource.source_line =
          'C:\\path\\to\\cookbooks/nope/recipes/default.rb:22'
        expect(subject.matches?(resource)).to be_truthy
      end
    end

    context 'when resource#source_line is not under target cookbook' do
      it 'normal unix path returns falsey' do
        resource.source_line =
          '/path/to/cookbooks/cookbookery/recipes/default.rb:22'
        expect(subject.matches?(resource)).to be_falsey
      end

      it 'normal windows path returns falsey' do
        resource.source_line =
          'C:\\path\\to\\cookbooks\\cookbookery\\recipes\\default.rb:22'
        expect(subject.matches?(resource)).to be_falsey
      end

      it 'mixed windows path returns falsey' do
        resource.source_line =
          'C:\\path\\to\\cookbooks/cookbookery/recipes/default.rb:22'
        expect(subject.matches?(resource)).to be_falsey
      end
    end
  end
end
