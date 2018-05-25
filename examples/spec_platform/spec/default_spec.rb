describe 'spec_platform' do
  context 'with no platform' do
    before do
      expect($stderr).to receive(:puts).with(/WARNING: you must specify/)
    end
    it { is_expected.to write_log("Hello chefspec 0.6.1") }
  end

  context 'with an ubuntu platform' do
    platform 'ubuntu', '16.04'
    it { is_expected.to write_log('Hello ubuntu 16.04') }
  end

  context 'with a freebsd platform' do
    platform 'freebsd', '11.1'
    it { is_expected.to write_log('Hello freebsd 11.1-RELEASE') }
  end

  context 'with a nested platform' do
    platform 'centos', '7.4.1708'
    context 'inner' do
      platform 'redhat', '7.5'
      it { is_expected.to write_log('Hello redhat 7.5') }
    end
  end
end
