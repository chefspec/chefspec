require 'chefspec'

describe 'chocolatey_package::remove' do
  platform 'windows'

  describe 'removes a package' do
    it { is_expected.to remove_chocolatey_package('7zip') }
  end

  describe 'removes a specific version of a package with options' do
    it {
      is_expected.to remove_chocolatey_package('git').with(
        version: %w(2.7.1)
      )
    }
  end
end
