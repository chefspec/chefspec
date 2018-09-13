describe 'stubs_for' do
  platform 'ubuntu'
  step_into :stubs_for_test, :stubs_for_old
  default_attributes['test'] = {run_load: false, run_resource: false, run_provider: false, user: nil}
  recipe do
    stubs_for_test 'test' do
      cmd 'this_is_not_a_cmd'
      run_load node['test']['run_load']
      run_resource node['test']['run_resource']
      run_provider node['test']['run_provider']
      user node['test']['user']
    end
  end

  context 'with no stubs' do
    context 'running nothing' do
      it { expect { subject }.to_not raise_error }
    end

    context 'running load' do
      default_attributes['test']['run_load'] = true
      it { expect { subject }.to raise_error ChefSpec::Error::ShellOutNotStubbed }
    end

    context 'running resource' do
      default_attributes['test']['run_resource'] = true
      it { expect { subject }.to raise_error ChefSpec::Error::ShellOutNotStubbed }
    end

    context 'running provider' do
      default_attributes['test']['run_provider'] = true
      it { expect { subject }.to raise_error ChefSpec::Error::ShellOutNotStubbed }
    end

    context 'running all three' do
      default_attributes['test'] = {run_load: true, run_resource: true, run_provider: true}
      it { expect { subject }.to raise_error ChefSpec::Error::ShellOutNotStubbed }
    end
  end

  context 'with a single inline resource stub' do
    context 'running load' do
      default_attributes['test']['run_load'] = true

      it do
        stubs_for_resource('stubs_for_test[test]') do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end
        subject
      end

      it do
        stubs_for_current_resource('stubs_for_test[test]') do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end
        subject
      end

      it do
        stubs_for_resource('stubs_for_test[test]', current_resource: false) do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end
        expect { subject }.to raise_error ChefSpec::Error::ShellOutNotStubbed
      end

      context 'with old-style load_current_resource' do
        recipe do
          stubs_for_old 'test' do
            cmd 'this_is_not_a_cmd'
            run_load true
          end
        end

        it do
          stubs_for_current_resource('stubs_for_old[test]') do |res|
            allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
          end
          subject
        end
      end
    end

    context 'running resource' do
      default_attributes['test']['run_resource'] = true

      it do
        stubs_for_resource('stubs_for_test[test]') do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end
        is_expected.to run_stubs_for_test('test').with(foo: 'asdf')
      end
    end

    context 'running both' do
      default_attributes['test']['run_load'] = true
      default_attributes['test']['run_resource'] = true

      it do
        stubs_for_resource('stubs_for_test[test]') do |res|
          # Use expect instead of allow for this test.
          expect(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf').at_least(:once)
        end
        is_expected.to run_stubs_for_test('test').with(foo: 'asdf')
      end
    end
  end

  context 'with a single inline provider stub' do
    default_attributes['test']['run_provider'] = true

    it do
      stubs_for_provider('stubs_for_test[test]') do |prov|
        allow(prov).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
      end
      subject
    end

    context 'with a user' do
      default_attributes['test']['user'] = 'foo'

      it do
        stubs_for_provider('stubs_for_test[test]') do |prov|
          allow(prov).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf', user: 'foo')
        end
        subject
      end
    end

    context 'with a user and a generic stub' do
      default_attributes['test']['user'] = 'foo'

      it do
        stubs_for_provider('stubs_for_test[test]') do |prov|
          allow(prov).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end
        subject
      end
    end
  end

  context 'with a single group-level resource stub' do
    context 'running load' do
      default_attributes['test']['run_load'] = true

      context 'with normal usage' do
        stubs_for_resource('stubs_for_test[test]') do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end

        it { subject }
      end

      context 'with stubs_for_current_resource' do
        stubs_for_current_resource('stubs_for_test[test]') do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end

        it { subject }
      end

      context 'with current_resource: false' do
        stubs_for_resource('stubs_for_test[test]', current_resource: false) do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
        end
        it { expect { subject }.to raise_error ChefSpec::Error::ShellOutNotStubbed }
      end
    end

    context 'running resource' do
      default_attributes['test']['run_resource'] = true

      stubs_for_resource('stubs_for_test[test]') do |res|
        allow(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf')
      end

      it { is_expected.to run_stubs_for_test('test').with(foo: 'asdf') }
    end

    context 'running both' do
      default_attributes['test']['run_load'] = true
      default_attributes['test']['run_resource'] = true

      stubs_for_resource('stubs_for_test[test]') do |res|
        # Use expect instead of allow for this test.
        expect(res).to receive_shell_out('this_is_not_a_cmd', stdout: 'asdf').at_least(:once)
      end

      it { is_expected.to run_stubs_for_test('test').with(foo: 'asdf') }
    end
  end

  context 'with multiple nested stubs' do
    recipe do
      stubs_for_test 'test1' do
        cmd 'this_is_not_a_cmd1'
        run_resource true
      end
      stubs_for_test 'test2' do
        cmd 'this_is_not_a_cmd2'
        run_resource true
      end
      stubs_for_test 'test3' do
        cmd 'this_is_not_a_cmd2'
        run_resource true
      end
      stubs_for_old 'test4' do
        cmd 'this_is_not_a_cmd3'
        run_resource true
      end
    end

    stubs_for_resource('stubs_for_test[test1]') do |res|
      allow(res).to receive_shell_out('this_is_not_a_cmd1', stdout: 'one')
    end
    stubs_for_resource('stubs_for_test') do |res|
      allow(res).to receive_shell_out('this_is_not_a_cmd2', stdout: 'two')
    end
    stubs_for_resource do |res|
      allow(res).to receive_shell_out('this_is_not_a_cmd3', stdout: 'three')
    end

    it { is_expected.to run_stubs_for_test('test1').with(foo: 'one') }
    it { is_expected.to run_stubs_for_test('test2').with(foo: 'two') }
    it { is_expected.to run_stubs_for_test('test3').with(foo: 'two') }
    it { is_expected.to run_stubs_for_old('test4').with(foo: 'three') }

    context 'nested a' do
      stubs_for_resource('stubs_for_test[test1]') do |res|
        allow(res).to receive_shell_out('this_is_not_a_cmd1', stdout: 'four')
      end

      it { is_expected.to run_stubs_for_test('test1').with(foo: 'four') }
      it { is_expected.to run_stubs_for_test('test2').with(foo: 'two') }
      it { is_expected.to run_stubs_for_test('test3').with(foo: 'two') }
      it { is_expected.to run_stubs_for_old('test4').with(foo: 'three') }

      context 'nested b' do
        stubs_for_resource do |res|
          allow(res).to receive_shell_out('this_is_not_a_cmd3', stdout: 'five')
        end

        it { is_expected.to run_stubs_for_test('test1').with(foo: 'four') }
        it { is_expected.to run_stubs_for_test('test2').with(foo: 'two') }
        it { is_expected.to run_stubs_for_test('test3').with(foo: 'two') }
        it { is_expected.to run_stubs_for_old('test4').with(foo: 'five') }
      end
    end

    context 'nested c' do
      stubs_for_resource('stubs_for_test') do |res|
        allow(res).to receive_shell_out('this_is_not_a_cmd2', stdout: 'six')
      end
      stubs_for_resource do |res|
        allow(res).to receive_shell_out('this_is_not_a_cmd3', stdout: 'seven')
      end

      it { is_expected.to run_stubs_for_test('test1').with(foo: 'one') }
      it { is_expected.to run_stubs_for_test('test2').with(foo: 'six') }
      it { is_expected.to run_stubs_for_test('test3').with(foo: 'six') }
      it { is_expected.to run_stubs_for_old('test4').with(foo: 'seven') }
    end
  end
end
