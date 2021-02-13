require 'chefspec'

describe 'compile_time::default' do
  platform 'ubuntu'

  describe 'matches without .at_compile_time' do
    it { is_expected.to install_package('compile_time') }
  end

  describe 'matches with .at_compile_time' do
    it { is_expected.to install_package('compile_time').at_compile_time }
  end

  describe 'does not match when the resource is not at compile time' do
    it { is_expected.to_not install_package('converge_time').at_compile_time }
  end

  describe 'matches without .at_converge_time' do
    it { is_expected.to install_package('converge_time') }
  end

  describe 'matches with .at_converge_time' do
    it { is_expected.to install_package('converge_time').at_converge_time }
  end

  describe 'does not match when the resource is not at converge time' do
    it { is_expected.to_not install_package('compile_time').at_converge_time }
  end
end
