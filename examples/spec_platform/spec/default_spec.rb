describe 'spec_platform' do
  context 'with no platform' do
    before do
      expect($stderr).to receive(:puts).with(/WARNING: you must specify/)
    end
    it { is_expected.to write_log('test').with_message('Hello chefspec 0.6.1') }
  end

  context 'with an ubuntu platform' do
    platform 'ubuntu', '18.04'
    it { is_expected.to write_log('test').with_message('Hello ubuntu 18.04') }
  end

  context 'with a freebsd platform' do
    platform 'freebsd', '11.2'
    it { is_expected.to write_log('test').with_message('Hello freebsd 11.2-RELEASE') }
  end

  context 'with a nested platform' do
    platform 'ubuntu', '18.04'
    context 'inner' do
      platform 'redhat', '8'
      it { is_expected.to write_log('test').with_message('Hello redhat 8') }
    end
  end

  context 'with no version' do
    platform 'windows'
    it { is_expected.to write_log('test').with_message(/Hello windows/) }
  end

  context 'with a partial version' do
    platform 'centos', '6'
    it { is_expected.to write_log('test').with_message('Hello centos 6.10') }
  end
end
