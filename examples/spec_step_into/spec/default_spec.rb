describe 'spec_step_into' do
  platform 'ubuntu', '16.04'

  context 'with no step_into' do
    it { is_expected.to_not write_log('one') }
    it { is_expected.to_not write_log('two') }
  end

  context 'with step_into one' do
    step_into :spec_step_into_one
    it { is_expected.to write_log('one') }
    it { is_expected.to_not write_log('two') }

    context 'with nested step_into one' do
      step_into :spec_step_into_one
      it { is_expected.to write_log('one') }
      it { is_expected.to_not write_log('two') }
    end

    context 'with nested step_into two' do
      step_into :spec_step_into_two
      it { is_expected.to write_log('one') }
      it { is_expected.to write_log('two') }
    end
  end

  context 'with step_into two' do
    step_into :spec_step_into_two
    it { is_expected.to_not write_log('one') }
    it { is_expected.to write_log('two') }
  end

  context 'with step_into both' do
    step_into :spec_step_into_one, :spec_step_into_two
    it { is_expected.to write_log('one') }
    it { is_expected.to write_log('two') }
  end

  context 'with step_into as a string' do
    step_into 'spec_step_into_one'
    it { is_expected.to write_log('one') }
    it { is_expected.to_not write_log('two') }
  end

  context 'with step_into as an array' do
    step_into [:spec_step_into_one]
    it { is_expected.to write_log('one') }
    it { is_expected.to_not write_log('two') }
  end
end
