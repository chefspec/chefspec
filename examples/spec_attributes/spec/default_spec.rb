describe 'spec_attributes' do
  platform 'centos', '7.4.1708'

  context 'with no attribute changes' do
    it { is_expected.to install_package('myapp').with_version('1.0') }
    it { is_expected.to write_log('version=1.0') }
  end

  context 'with an extra attribute' do
    default_attributes['myapp']['other'] = 'foo'

    it { is_expected.to install_package('myapp').with_version('1.0') }
    it { is_expected.to write_log('other=foo version=1.0') }
  end

  context 'with version at the default level' do
    default_attributes['myapp']['version'] = '2.0'

    it { is_expected.to install_package('myapp').with_version('2.0') }
    it { is_expected.to write_log('version=2.0') }
  end

  context 'with version at the override level' do
    override_attributes['myapp']['version'] = '2.0'

    it { is_expected.to install_package('myapp').with_version('2.0') }
    it { is_expected.to write_log('version=2.0') }
  end

  context 'with multiple attributes' do
    default_attributes['other'] = 'does nothing'
    default_attributes['myapp']['version'] = '3.0'
    default_attributes['myapp']['thing1'] = 'one'
    override_attributes['myapp']['thing2'] = 'two'

    it { is_expected.to install_package('myapp').with_version('3.0') }
    it { is_expected.to write_log('thing1=one thing2=two version=3.0') }

    context 'in a nested context' do
      default_attributes['myapp']['thing1'] = 'uno'
      default_attributes['myapp']['thing2'] = 'dos'

      it { is_expected.to install_package('myapp').with_version('3.0') }
      it { is_expected.to write_log('thing1=uno thing2=two version=3.0') }
    end

    context 'with setting via a hash' do
      default_attributes['myapp'] = { thing1: 'un' }

      it { is_expected.to install_package('myapp').with_version('3.0') }
      it { is_expected.to write_log('thing1=un thing2=two version=3.0') }
    end
  end

  context 'before attributes' do
    before do
      chefspec_default_attributes['myapp'] ||= {}
      chefspec_default_attributes['myapp']['version'] = '4.0'
    end

    it { is_expected.to write_log('version=4.0') }
  end
end
