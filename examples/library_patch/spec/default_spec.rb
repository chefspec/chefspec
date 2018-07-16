describe 'library_patch' do
  platform 'ubuntu', '18.04'

  context 'with no patch' do
    it { is_expected.to write_log('Hello 1') }
  end

  context 'with a patch' do
    before do
      expect(LibraryPatchHelpers).to receive(:helper_method).and_return(2)
    end
    it { is_expected.to write_log('Hello 2') }
  end
end
